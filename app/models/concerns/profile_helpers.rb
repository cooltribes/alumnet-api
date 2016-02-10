module ProfileHelpers

  def empty_location_info
    { id: nil, name: "", cc_iso: nil }
  end

  def birth_city_info
    { id: birth_city_id, name: birth_city.try(:name) || "", cc_iso: birth_city.try(:cc_iso) }
  end

  def birth_country_info
    { id: birth_country_id, name: birth_country.try(:name) || "", cc_iso: birth_country.try(:cc_iso) }
  end

  def residence_city_info
    { id: residence_city_id, name: residence_city.try(:name) || "", cc_iso: residence_city.try(:cc_iso) }
  end

  def residence_country_info
    { id: residence_country_id, name: residence_country.try(:name) || "", cc_iso: residence_country.try(:cc_iso) }
  end

  def permit_birth_city(user)
    return birth_city_info if user.permit('see-born', user)
    empty_location_info
  end

  def permit_birth_country(user)
    return birth_country_info if user.permit('see-born', user)
    empty_location_info
  end

  def permit_residence_city(user)
    return residence_city_info if user.permit('see-residence', user)
    empty_location_info
  end

  def permit_residence_country(user)
    return residence_country_info if user.permit('see-residence', user)
    empty_location_info
  end

  def residence_region
    if residence_country && residence_country.region.present?
      { id: residence_country.region.id, name: residence_country.region.name }
    else
      { id: nil, name: "" }
    end
  end

  def permit_last_experience(user)
    if last_experience.present? && user.permit('see-job', user)
      last_experience.name
    else
      nil
    end
  end

  def permit_born(user)
    if born
      if user.permit('see-birthdate', user) && user.permit('see-birth-year', user)
        { day: born.day, month: born.month, year: born.year }
      elsif user.permit('see-birthdate', user)
        { day: born.day, month: born.month, year: nil }
      elsif user.permit('see-birth-year', user)
        { day: nil, month: nil, year: born.year }
      else
        { day: nil, month: nil, year: nil }
      end
    end
  end

  #For public profiles
  def completeBorn(user)
    #Date
    bornDate = permit_born(user)
    array = []
    array.push(bornDate[:year]) if bornDate[:year]
    array.push(bornDate[:month]) if bornDate[:month]
    array.push(bornDate[:day]) if bornDate[:day]
    completeDate = array.join("/")

    #Location of origin
    city = permit_birth_city(user)
    completeLocation = nil
    if city
      country = permit_birth_country(user)
      completeLocation = "#{city[:name]} - #{country[:name]}"
    end

    #Born (date and location)
    array = []
    array.push(completeLocation) if completeLocation
    array.push(completeDate) if completeDate != ""
    completeBorn = array.join(" in ")
  end

  def residenceLocation(user)
    city = permit_residence_city(user)
    completeLocation = nil
    if city
      country = permit_residence_country(user)
      completeLocation = "#{city[:name]} - #{country[:name]}"
    end

  end



end