class V1::MeController < V1::BaseController
  before_action :set_user

  def show
    if browser.platform.ios? || browser.platform.android? || browser.platform.other?
      render 'mobile/me/me'
    end
  end

  def identity_layer
    token = Layer::IdentityToken.new(@user.id, params[:nonce], (Time.now+(86400*14)))
    render json: token
  end

  def profinda_token
    if @user.profinda_uid.present?
      profinda_api = ProfindaApiClient.new(@user.email, @user.profinda_password)
    else
      profinda_api = @user.save_data_in_profinda #TODO: esto es raro. refactorizar en proxima ver. :armando
    end

    if profinda_api.valid?
      render json: { profinda_api_token: profinda_api.api_token }
    else
      render json: { errors: profinda_api.errors }, status: :unprocessable_entity
    end
  end

  def receptive_settings
    unsigned_snippet = {
      "timestamp" => DateTime.now.iso8601,
      "account" => {
        "id" => @user.role,
        "is_paying" => (@user.is_premium?).to_s,
        "monthly_value" => (@user.receptive_points).to_s
      },
      "vendor" => {
        "id" => Settings.receptive_vendor_id
      },
      "user" => {
        "full_name" => @user.name,
        "email" => @user.email,
        "id" => @user.id.to_s
      },
      "return_url" => Settings.ui_endpoint,
    }

    render json: { settings: sign_snippet(unsigned_snippet) }
  end

  #Only for users created by admins, they approve themselves in the middle of the registration
  def activate
    if @user.inactive? && @user.created_by_admin?
      if @user.is_regular? && @user.profile.penultimate_step_complete?
        @user.activate!
        @user.save_profinda_profile
        render json: { status: 'active' }
      elsif @user.is_external? && @user.profile.first_step_completed?
        @user.activate!
        render json: { status: 'active' }
      else
        render json: { status: 'user can\'t be activate' }
      end
    else
      render json: { status: 'user is active' }
    end
  end

  def send_invitations
    sender = SenderInvitation.new(params[:contacts], current_user)
    if sender.valid?
      sender.send_invitations
      render json: { status: 'ok', count: sender.count }
    else
      render json: { errors: sender.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def messages
    @receipts = @user.messages_with_includes.limit(6)
    render "v1/me/receipts/index", status: :ok
  end

  def update
    if @user.update(user_params)
      render :show, status: :ok,  location: me_path
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  private
    def user_params
      params.permit(:email, :password, :password_confirmation, :show_onboarding)
    end

    def set_user
      @user = current_user if current_user
    end

    def sign_snippet(unsigned)
      concat_values = ([Settings.receptive_secret_key] + [unsigned["return_url"]] + [unsigned["timestamp"]] + unsigned["account"].values + unsigned["user"].values + unsigned["vendor"].values).sort.join(",")
      signature = Digest::SHA256.new << concat_values
      unsigned["signature"] = signature.to_s
      unsigned
    end
end