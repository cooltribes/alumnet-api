class V1::Me::GroupsController < V1::BaseController
  before_action :set_user

  def index
    q = current_user.created_groups.ransack(params[:q])
    @groups = q.result
  end

  def my_groups
    q = current_user.groups.ransack(params[:q])
    @groups = q.result
    render :index
  end

  private
    def set_user
      @user = current_user if current_user
    end
end
