class AlumnetSearcher

  def initialize(params)
    @query = params.delete(:q) || params.delete(:term)
    @type =  params.delete(:type)
    @page = params.delete(:page)
  end

  def get_results
    if @type && searcheable
      searcheable.search(@query).page(@page).results
    else
      Elasticsearch::Model.search(@query, searchable_models).page(@page).results
    end
  end

  def results
    get_results.to_a.map(&:to_hash) if get_results
  end

  def suggestions
    if get_results
      get_results.each_with_object([]) do |result, array|
        image = if result._type == "group" || result._type == "event"
          result._source.cover.small.url
        elsif result._type == "profile"
          result._source.avatar.small.url
        elsif result._type == "company"
          result._source.logo.small.url
        elsif result._type == "task"
          nil # buscar una imagen por default
        else
          nil
        end
        array << { image: image, id: result._source.id, name: result._source.name, type: result._type }
      end
    end
  end

  def searcheable
    model = @type.capitalize.constantize
    return model if searchable_models.include?(model)
  rescue
    return nil
  end

  def searchable_models
    [Group, Event, Company, Task, Profile]
  end
end