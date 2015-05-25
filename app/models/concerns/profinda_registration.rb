module ProfindaRegistration


  def update_or_create_profinda_profile
    profinda_api = ProfindaApi.sign_in_or_sign_up(email, profinda_password)
    if profinda_api.valid?
      profinda_api.profile = info_for_profinda_registration
      true
    else
      false
    end
  end

  def info_for_profinda_registration
    {
      "first_name" => profile.first_name,
      "last_name" => profile.last_name,
      "male" => profinda_gender,
      "pcf_skills" => skills_for_profinda,
      "pcf_languages" => languages_for_profinda
    }
  end

  def profinda_gender
    profile.gender == "M" ? "1" : "0"
  end

  def skills_for_profinda
    profile.skills.map(&:name).join("&#x2c;")
  end

  def languages_for_profinda
    profile.languages.map(&:name).join("&#x2c;")
  end

end