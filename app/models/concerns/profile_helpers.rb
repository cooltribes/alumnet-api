module ProfileHelpers

  def permit_birth_city(user)
    if self.birth_city.present? && self.user.permit('see-born', user)
      { id: self.birth_city.id, text: self.birth_city.name }
    else
      { id: nil, text: "" }
    end
  end

  def permit_birth_country(user)
    if self.birth_country.present? && self.user.permit('see-born', user)
      { id: self.birth_country.id, text: self.birth_country.name }
    else
      { id: nil, text: "" }
    end
  end

  def permit_residence_city(user)
    if self.residence_city.present? && self.user.permit('see-residence', user)
      { id: self.residence_city.id, text: self.residence_city.name }
    else
      { id: nil, text: "" }
    end
  end

  def permit_residence_country(user)
    if self.residence_country.present? && self.user.permit('see-residence', user)
      { id: self.residence_country.id, text: self.residence_country.name,
        region: residence_region }
    else
      { id: nil, text: "" }
    end
  end

  def residence_region
    if self.residence_country.region.present?
      { id: self.residence_country.region.id, name: self.residence_country.region.name }
    else
      { id: nil, name: "" }
    end
  end

  def permit_last_experience(user)
    if self.last_experience.present? && self.user.permit('see-job', user)
      self.last_experience.name
    else
      nil
    end
  end

  def permit_born(user)
    if self.born
      if self.user.permit('see-birthdate', user) && self.user.permit('see-birth-year', user)
        { day: self.born.day, month: self.born.month, year: self.born.year }
      elsif self.user.permit('see-birthdate', user)
        { day: self.born.day, month: self.born.month, year: nil }
      elsif self.user.permit('see-birth-year', user)
        { day: nil, month: nil, year: self.born.year }
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
      completeLocation = "#{city[:text]} - #{country[:text]}"
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
      completeLocation = "#{city[:text]} - #{country[:text]}"
    end

  end



end