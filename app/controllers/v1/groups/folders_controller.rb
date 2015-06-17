class V1::Groups::FoldersController < V1::BaseFoldersController

  private

  def set_folderable
    @folderable = Group.find(params[:group_id])
  end

end
