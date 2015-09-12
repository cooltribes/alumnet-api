class V1::Me::SuggestionsController < V1::BaseController
  before_action :set_user

  def groups
    @groups = @user.suggested_groups.limit(6)
  end

  def users
    @users = @user.suggested_users.limit(6)
  end

  private
    def set_user
      @user = current_user if current_user
    end
end
