class V1::Me::SuggestionsController < V1::BaseController
  before_action :set_user

  def groups
    @groups = @user.suggested_groups(params[:limit])
  end

  def users
    @users = @user.suggested_users(params[:limit])
  end

  def events
    @events = @user.suggested_events(params[:limit])
  end

  private
    def set_user
      @user = current_user if current_user
    end
end
