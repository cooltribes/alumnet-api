class AlumnetSearcher

  def initialize(params)
    @query = params.delete(:q) || params.delete(:term)
    @type =  params.delete(:type)
    @page = params.delete(:page)
  end

  def results
    results = if @type && searcheable
      searcheable.search(@query).page(@page).results
    else
      Elasticsearch::Model.search(@query, searchable_models).page(@page).results
    end
    results.to_a.map(&:to_hash) if results
  end

  def suggestions
    if results
      results.each_with_object([]) do |result, array|
        if result["_type"] == "group" || result["_type"] == "event"
          array << { id: result["_source"]["id"], name: result["_source"]["name"], type: result["_type"] }
        end
      end
    end
  end

  def searcheable
    model = @type.capitalize.constantize
    return model if searchable_models.include?(model)
  end

  def searchable_models
    [Group, Event, Company, Task, Profile]
  end
end