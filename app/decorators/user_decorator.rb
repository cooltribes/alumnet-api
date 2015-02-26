class UserDecorator < Draper::Decorator
  delegate_all

  def name
    "#{object.profile.first_name} #{object.profile.last_name}"
  end

  def hidden_name
    "#{object.profile.first_name} #{object.profile.hidden_last_name}"
  end

  def permit_name(user)
    if object.permit('see-name', user)
      "#{object.profile.first_name} #{object.profile.last_name}"
    else
      "#{object.profile.first_name} #{object.profile.hidden_last_name}"
    end
  end
end
