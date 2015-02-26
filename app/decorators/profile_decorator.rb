class ProfileDecorator < Draper::Decorator
  delegate_all

  def permit_birth_city(user)
    if object.birth_city.present?
      { id: object.birth_city.id, text: object.birth_city.name }
    else
      nil
    end
  end

  def permit_birth_country(user)
    if object.birth_country.present?
      { id: object.birth_country.id, text: object.birth_country.name }
    else
      nil
    end
  end

  def permit_residence_city(user)
    if object.residence_city.present?
      { id: object.residence_city.id, text: object.residence_city.name }
    else
      nil
    end
  end

  def permit_residence_country(user)
    if object.residence_country.present?
      { id: object.residence_country.id, text: object.residence_country.name }
    else
      nil
    end
  end

  def permit_last_experience(user)
    if object.last_experience.present?
      object.last_experience.name
    else
      nil
    end
  end
end