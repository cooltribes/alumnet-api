module EventHelpers

  def event_type_info
    { text: event_type, value: Event.event_types[event_type] }
  end

end
