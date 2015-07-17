module StatsHelper
  def make_regional_admin
    @region = Region.make!(name: "America")
    ["Colombia", "Chile", "Ecuador", "Venezuela"].each do |country|
      Country.make!(name: country, region: @region)
    end
    @admin = User.make!(role: User::ROLES[:regional_admin], admin_location: @region)
  end

  def make_local_admin
    @country = Country.make!(name: country, region: @region)
    @admin = User.make!(role: User::ROLES[:regional_admin], admin_location: @country)
  end

  def activate_user(user)
    user.profile.skills!
    user.activate_in_alumnet
  end

  def make_regular_active_user(country, active_date = Date.today)
    user = User.make!
    user.profile.update(residence_country_id: country.id)
    activate_user(user)
    user.update(active_at: active_date)
  end

  def make_lifetime_active_user(country, active_date = Date.today)
    user = User.make!
    UserSubscription.make!(:lifetime, user: user, creator: user, start_date: active_date)
    user.profile.update(residence_country_id: country.id)
    activate_user(user)
    user.update(active_at: Date.parse('21-08-2001'), member: 1)
  end

  def make_member_active_user(country, active_date = Date.today)
    user = User.make!
    UserSubscription.make!(:lifetime, user: user, creator: user, start_date: active_date)
    user.profile.update(residence_country_id: country.id)
    activate_user(user)
    user.update(active_at: Date.parse('21-08-2001'), member: 1)
  end

  def make_member_active_user(country, active_date = Date.today)
    user = User.make!
    UserSubscription.make!(:premium, user: user, creator: user, start_date: active_date)
    user.profile.update(residence_country_id: country.id)
    activate_user(user)
    user.update(active_at: Date.parse('21-08-2001'), member: 1)
  end
end