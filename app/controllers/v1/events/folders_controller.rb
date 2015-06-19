class V1::Events::FoldersController < V1::BaseFoldersController

  private

  def set_folderable
    @folderable = Event.find(params[:event_id])
  end

end
