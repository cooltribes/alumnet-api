class V1::SearchController < V1::BaseController

  def search
    searcher = AlumnetSearcher.new(params)
    render json: searcher.results_filter_secret_groups(searcher.results, current_user)
  end

  def suggestions
    searcher = AlumnetSearcher.new(params)
    render json: searcher.suggestions_filter_secret_groups(searcher.suggestions, current_user)
  end

end