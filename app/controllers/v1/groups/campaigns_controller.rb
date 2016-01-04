require 'mailchimp'

class V1::Groups::CampaignsController < V1::BaseController
  before_action :set_group
  before_action :set_campaign, only: [:update, :destroy, :show]
  before_action :set_user, only: :create
  before_action :set_mailchimp

  def index
    @campaigns = @group.campaigns
  end

  def create
    @campaign = Campaign.new(campaign_params)
    if @group.mailchimp
      @campaign.status = :saved
      @campaign.list_id = @group.list_id
      if @campaign.save
        #@response = @campaign.save_campaign(@mailchimp, @group)
        @response = @mailchimp.campaigns.create('regular', 
          {
            'list_id' => @group.list_id, 
            'subject' => @campaign.subject, 
            'from_email' => 'yondri@gmail.com',
            'from_name' => 'Alumnet',
            'to_name' => @group.name
          },
          {
            'html' => @campaign.body
          }
        )
        @campaign.update(provider_id: @response['id'])
        #@campaign.send()
        #@mailchimp.campaigns.send_test(@campaign.provider_id, ['yroa@upsidecorp.ch'])
        @mailchimp.campaigns.send(@campaign.provider_id)
        #@sent_campaign = @mailchimp.campaigns.list({'campaign_id' => @campaign.provider_id})
        #render json: @response
        render :show, status: :created
      end
    else
      render json: @campaign.errors, status: :unprocessable_entity
    end
  end

  def show
    @response = @mailchimp.campaigns.list({'campaign_id' => @campaign.provider_id})
    render json: @response['data'][0]
  end

  # def update
  #   if @campaign.update(campaign_params)

  #     Notification.notify_group_join_accepted_to_user(@campaign.user, @group)

  #     if @group.mailchimp
  #       if @campaign.approved
  #         @mc_group = Mailchimp::API.new(@group.api_key)
  #         @campaign.user.subscribe_to_mailchimp_list(@mc_group, @group.list_id)
  #       else
  #         @mc_group.lists.unsubscribe(@group.list_id, {'email' => @campaign.user.email}, false, false, true)
  #       end
  #     end
  #     render :show
  #   else
  #     render json: @campaign.errors, status: :unprocessable_entity
  #   end
  # end

  # def destroy
  #   email = @campaign.user.email
  #   @campaign.really_destroy!
  #   if @group.mailchimp
  #     @mc_group = Mailchimp::API.new(@group.api_key)
  #     @mc_group.lists.unsubscribe(@group.list_id, {'email' => email}, false, false, true)
  #   end
  #   head :no_content
  # end

  private
    def set_group
      @group = Group.find(params[:group_id])
    end

    def set_campaign
      @campaign = @group.campaigns.find(params[:id])
    end

    def set_user
      unless @user = User.find_by(id: params[:user_id])
        render json: { error: "User not found" }
      end
    end

    def set_mailchimp
      if @group.mailchimp
        @mailchimp = Mailchimp::API.new(@group.api_key)
      else
        @mailchimp = nil
      end
    end

    def campaign_params
      params.permit(:user_id, :group_id, :subject, :body)
    end
end
