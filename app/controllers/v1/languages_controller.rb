class V1::LanguagesController < V1::BaseController
  before_action :set_country, except: [:index]

  def index
    @q = Language.search(params[:q])
    @languages = @q.result
  end

end