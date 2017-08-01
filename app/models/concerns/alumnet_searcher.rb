class AlumnetSearcher

  SEARCHEABLE_MODELS = [Group, Event, Company, Task, Profile]

  def initialize(params)
    @query = params.delete(:q) || params.delete(:term)
    @type =  params.delete(:type)
    @page = params.delete(:page)
  end

  def get_response
    if @type && searcheable
      searcheable.search(@query).page(@page).per(25)
    else
      Elasticsearch::Model.search(@query, SEARCHEABLE_MODELS).page(@page).per(25)
    end
  end

  def ar_results
    get_response.records if get_response
  end

  def results
    get_response.results.to_a.map(&:to_hash) if get_response
  end

  def suggestions
    if get_response
      get_response.results.each_with_object([]) do |result, array|
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

        # change profile id for user id
        id = result._source.id
        if result._type == 'profile'
          result._source.user_id
        end
        array << { image: image, id: id, name: result._source.name, type: result._type }
      end
    end
  end

  def searcheable
    model = @type.capitalize.constantize
    return model if SEARCHEABLE_MODELS.include?(model)
  rescue
    return nil
  end

  def suggestions_filter_secret_groups(results, current_user)
    results.each do |result|
      if result[:type] == 'group'
        group = Group.find(result[:id])
        results.delete(result) if !group.user_has_membership?(current_user)
      end
    end
    results
  end

  def results_filter_secret_groups(results, current_user)
    results.each do |result|
      if result['_type'] == 'group'
        group = Group.find(result['_id'])
        results.delete(result) if !group.user_has_membership?(current_user)
      end
    end
    results
  end

end