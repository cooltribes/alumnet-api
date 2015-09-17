module StatsHelper
  def make_regional_admin
    @region = Region.make!(name: "America")
    ["Colombia", "Chile", "Ecuador", "Venezuela"].each do |country|
      Country.make!(:simple, name: country, region: @region)
    end
    @admin = User.make!(role: User::ROLES[:regional_admin], admin_location: @region)
  end

  def make_local_admin(country, region = Region.make!)
    @country = Country.make!(:simple, name: country, region: region)
    @admin = User.make!(role: User::ROLES[:nacional_admin], admin_location: @country)
  end

  def activate_user(user)
    user.profile.set_last_register_step!
    user.activate_in_alumnet
  end

  def make_regular_active_user(country, active_date = Date.today)
    user = User.make!
    user.profile.update(residence_country_id: country.id)
    activate_user(user)
    user.update(active_at: active_date)
    user
  end

  def make_external_active_user(country, active_date = Date.today)
    user = User.make!(role: User::ROLES[:external])
    user.profile.update(residence_country_id: country.id)
    activate_user(user)
    user.update(active_at: active_date)
    user
  end

  def make_lifetime_active_user(country, active_date = Date.today)
    user = User.make!
    Subscription.make!(:lifetime, user: user, creator: user, start_date: active_date)
    user.profile.update(residence_country_id: country.id)
    activate_user(user)
    user.update(active_at: Date.parse('21-08-2001'), member: 1)
    user
  end

  def make_member_active_user(country, active_date = Date.today)
    user = User.make!
    Subscription.make!(:premium, user: user, creator: user, start_date: active_date)
    user.profile.update(residence_country_id: country.id)
    activate_user(user)
    user.update(active_at: Date.parse('21-08-2001'), member: 1)
    user
  end
end