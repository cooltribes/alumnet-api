module EventHelpers

  def event_type_info
    { text: event_type, value: Event.event_types[event_type] }
  end

  def country_info
    if country
      { text: country.name, value: country_id}
    else
      { text: "", value: ""}
    end
  end

  def city_info
    if city
      { text: city.name, value: city_id}
    else
      { text: "", value: ""}
    end
  end

end
