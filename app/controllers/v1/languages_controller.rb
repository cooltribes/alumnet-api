class V1::LanguagesController < V1::BaseController

  def index
    @q = Language.ransack(params[:q])
    @languages = @q.result
  end
end