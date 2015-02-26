class V1::Admin::Deleted::GroupsController < V1::AdminController
  before_action :set_group, except: :index

  def index
    @q = Group.only_deleted.search(params[:q])
    @groups = @q.result
  end

  def update
    Group.restore(@group.id, recursive: true)
  end

  def destroy
    @group.really_destroy!
    head :no_content
  end

  private

  def set_group
    @group = Group.only_deleted.find(params[:id])
  end
end
