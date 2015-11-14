class V1::SearchController < V1::BaseController

  def search
  end

  def suggestions
    searcher = AlumnetSearcher.new(params)
    render json: searcher.suggestions
  end

end