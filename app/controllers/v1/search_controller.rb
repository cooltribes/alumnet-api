class V1::SearchController < V1::BaseController

  def search
    searcher = AlumnetSearcher.new(params)
    render json: searcher.results
  end

  def suggestions
    searcher = AlumnetSearcher.new(params)
    render json: searcher.suggestions
  end

end