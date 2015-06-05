module ProfindaRegistration

  def profinda_api_token
    profinda = ProfindaApi.new(email, profinda_password)
    profinda.api_token
  end

  def activate_in_profinda
    if profinda_uid.present?
      profinda = ProfindaAdminApi.new
      profinda.activate profinda_uid
    else
      false
    end
  end

  def suspend_in_profinda
    if profinda_uid.present?
      profinda = ProfindaAdminApi.new
      profinda.suspend profinda_uid
    else
      false
    end
  end

  def save_profinda_profile
    SaveProfindaProfileJob.perform_later(id) unless Rails.env.test?
  end

  def save_data_in_profinda
    profinda_api = ProfindaApi.sign_in_or_sign_up(email, profinda_password)
    if profinda_api.valid?
      set_profinda_uid(profinda_api.user['id'])
      profinda_api.profile = info_for_profinda_registration
    end
  end

  def info_for_profinda_registration
    {
      "first_name" => profile.first_name,
      "last_name" => profile.last_name,
      "male" => profinda_gender,
      "pcf_alumnet_skills" => skills_for_profinda,
      "pcf_alumnet_languages" => languages_for_profinda,
      "pcf_alumnet_city_origin" => city_origin_for_profinda,
      "pcf_alumnet_country_origin" => country_origin_for_profinda,
      "pcf_alumnet_city_residence" => city_residence_for_profinda,
      "pcf_alumnet_country_residence" => country_residence_for_profinda,
      "pcf_alumnet_organizations" => organizations_for_profinda,
      "pcf_alumnet_aisec_chapter" => committees_for_profinda
    }
  end

  def set_profinda_uid(id)
    update_column(:profinda_uid, id) unless profinda_uid.present?
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

  def organizations_for_profinda
    profile.experiences.non_alumnet.map(&:organization_name).join("&#x2c;")
  end

  def committees_for_profinda
    committees = []
    profile.experiences.aisec.each do |experience|
      committees << experience.committee.name if experience.committee
    end
    committees.join("&#x2c;")
  end

  def country_origin_for_profinda
    profile.birth_country.present? ? profile.birth_country.name : ''
  end

  def city_origin_for_profinda
    profile.birth_city.present? ? profile.birth_city.name : ''
  end

  def country_residence_for_profinda
    profile.residence_country.present? ? profile.residence_country.name : ''
  end

  def city_residence_for_profinda
    profile.residence_city.present? ? profile.residence_city.name : ''
  end
end