class V1::Admin::Deleted::UsersController < V1::AdminController
  before_action :set_user, except: :index

  def index
    @q = User.only_deleted.search(params[:q])
    @users = @q.result
  end

  def update
    User.restore(@user.id, recursive: true)
  end

  def destroy
    @user.really_destroy!
    head :no_content
  end

  private

  def set_user
    @user = User.only_deleted.find(params[:id])
  end
end
