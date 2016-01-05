class V1::Me::SuggestionsController < V1::BaseController
  before_action :set_user

  def groups
    @groups = @user.suggested_groups
  end

  def users
    #this is an array not ar:r
    @users = @user.suggested_users(params[:limit])
  end

  private
    def set_user
      @user = current_user if current_user
    end
end
