class AlumnetUsersStatistics
  attr_accessor :user

  def initialize(user)
    @user = user
  end

  def per_type_of_membership(init_date, end_date, interval)
    data = {}
    init_date = Date.parse(init_date) - 1
    end_date  = Date.parse(end_date) + 1
    registrants = group_and_count_registrants(init_date, end_date, interval)
    members     = group_and_count_members(init_date, end_date, interval)
    lifetime    = group_and_count_lifetime(init_date, end_date, interval)
    data[:line] = format_for_line_graph [registrants, members, lifetime], interval
    data[:pie]  = format_for_pie_graph [total_from_hash(registrants), total_from_hash(members),
      total_from_hash(lifetime) ]
    data
  end

  def per_country_and_region(init_date, end_date, geo = "countries")
    users = {}
    init_date = Date.parse(init_date) - 1
    end_date  = Date.parse(end_date) + 1
    if geo == "countries"
      ["registrants", "members", "lifetime"].each do |type|
        users[type] = group_and_count_users_by_country(type, init_date, end_date)
      end
      format_for_table_of_countries(users)
    else
      ["registrants", "members", "lifetime"].each do |type|
        users[type] = group_and_count_users_by_region(type, init_date, end_date)
      end
      format_for_table_of_regions(users)
    end
  end

  def group_and_count_registrants(init_date, end_date, interval)
    group_and_count_users query_for_registrants(init_date, end_date), interval
  end

  def group_and_count_members(init_date, end_date, interval)
    group_and_count_subscriptions query_for_members(init_date, end_date), interval
  end

  def group_and_count_lifetime(init_date, end_date, interval)
    group_and_count_subscriptions query_for_lifetime(init_date, end_date), interval
  end

  def group_and_count_users_by_country(type_users, init_date, end_date)
    query = get_query_for(type_users, init_date, end_date)
    if @user.is_system_admin? || @user.is_alumnet_admin?
      result = group_and_count_by_country(query)
    elsif @user.is_regional_admin?
      region = @user.admin_location
      result = group_and_count_by_country(query, region.countries.pluck(:id))
    elsif @user.is_nacional_admin?
      country = @user.admin_location
      result = group_and_count_by_country(query, [country.id])
    else
      return []
    end
    get_country_name(result)
  end

  def group_and_count_users_by_region(type_users, init_date, end_date)
    results = {}
    query = get_query_for(type_users, init_date, end_date)
    if @user.is_system_admin? || @user.is_alumnet_admin?
      Region.all.each do |region|
        results.merge!(group_and_count_by_region(query, region))
      end
    elsif @user.is_regional_admin?
      results.merge!(group_and_count_by_region(query, @user.admin_location))
    end
    results
  end

  ## QUERYS

  def get_query_for(name, init_date, end_date)
    send("query_for_#{name}", init_date, end_date)
  end

  def query_for_regular_users(init_date, end_date)
    User.where("date(active_at) between ? and ?", init_date, end_date).
      where(status: 1, member: 0).
      where(role: User::ROLES[:regular])
  end

  def query_for_admins(init_date, end_date)
    User.where("date(active_at) between ? and ?", init_date, end_date).
      where(status: 1, member: 0).
      where.not.(role: User::ROLES[:regular])
  end

  def query_for_registrants(init_date, end_date)
    User.where("date(active_at) between ? and ?", init_date, end_date).
      where(status: 1, member: 0)
  end

  def query_for_members(init_date, end_date)
    User.joins(:user_subscriptions).
      where("date(\"user_subscriptions\".start_date) between ? and ?", init_date, end_date).
      where(user_subscriptions: { lifetime: false, status: 1 }).
      where(status: 1, member: 1)
  end

  def query_for_lifetime(init_date, end_date)
    User.joins(:user_subscriptions).
      where("date(\"user_subscriptions\".start_date) between ? and ?", init_date, end_date).
      where(user_subscriptions: { lifetime: true, status: 1 }).
      where(status: 1, member: 1)
  end

  ## GROUPS AND OTHERS

  def group_and_count_users(query, interval = "years")
    if interval == "years"
      format_years_results query.group("date_part('year', active_at)").count
    elsif interval == "days"
      format_days_results query.group("date(active_at)").count
    elsif interval == "months"
      generate_data_by_month(query, "active_at")
    end
  end

  def group_and_count_subscriptions(query, interval = "years")
    if interval == "years"
      format_years_results query.group("date_part('year', \"user_subscriptions\".start_date)").count
    elsif interval == "days"
      format_days_results query.group("date(\"user_subscriptions\".start_date)").count
    elsif interval == "months"
      generate_data_by_month(query, "start_date")
    end
  end

  def generate_data_by_month(query, field)
    data = {}
    results = query.select("date_part('month', #{field}) as month, date_part('year', #{field}) as year, count(\"users\".id)")
      .group("date_part('month', #{field}), date_part('year', #{field})")
      .order("month, year")
    results.each do |result|
      data["#{result.month.to_i.to_s.rjust(2, '0')}-#{result.year.to_i}"] = result.count
    end
    data
  end

  def group_and_count_by_country(query, countries = [])
    results = query.joins(profile: :birth_country).group("\"profiles\".residence_country_id")
    if countries.any?
      results.where('profiles.residence_country_id' => countries).count
    else
      results.count
    end
  end

  def group_and_count_by_region(query, region)
    countries = region.countries.pluck(:id)
    results = group_and_count_by_country(query, countries)
    {region.name => total_from_hash(results)}
  end

  ### HELPERS
  def format_for_table_of_regions(data_users)
    data = []
    data << ["Region", "Registrants", "Members", "LT Members", "Total"]
    registrants, members, lifetime = data_users["registrants"], data_users["members"], data_users["lifetime"]
    keys = (registrants.keys + members.keys + lifetime.keys).uniq
    keys.each do |key|
      total = registrants[key].to_i + members[key].to_i + lifetime[key].to_i
      data << [key, registrants[key] || 0, members[key] || 0, lifetime[key] || 0, total]
    end
    data
  end

  def format_for_table_of_countries(data_users)
    data = []
    data << ["Country", "Registrants", "Members", "LT Members", "Total"]
    registrants, members, lifetime = data_users["registrants"], data_users["members"], data_users["lifetime"]
    keys = (registrants.keys + members.keys + lifetime.keys).uniq
    keys.each do |key|
      total = registrants[key].to_i + members[key].to_i + lifetime[key].to_i
      data << [key, registrants[key] || 0, members[key] || 0, lifetime[key] || 0, total]
    end
    data
  end

  def format_for_line_graph(data_array, interval)
    data = []
    data << [interval.capitalize, "Registrants", "Members", "LT Members"]
    registrants, members, lifetime = data_array[0], data_array[1], data_array[2]
    keys = (registrants.keys + members.keys + lifetime.keys).uniq
    keys.each do |key|
      data << [key, registrants[key] || 0, members[key] || 0, lifetime[key] || 0]
    end
    data
  end

  def format_for_pie_graph(data_array)
    data = []
    data << ["Users", "Count"]
    ["Registrants", "Members", "LT Members"].each_with_index do |value, index|
      data << [value, data_array[index]]
    end
    data
  end

  private

  def total_from_hash(hash)
    value = hash.values.reduce(:+)
    value ? value : 0
  end

  def format_years_results(result_hash)
    data = {}
    result_hash.each do |k,v|
      data["#{k.to_i.to_s}"] = v
    end
    data
  end

  def format_days_results(result_hash)
    data = {}
    result_hash.each do |k,v|
      data["#{k.strftime('%d-%m-%Y')}"] = v
    end
    data
  end

  def get_country_name(hash)
    data = {}
    @countries ||= get_countries
    hash.each do |k,v|
      data[@countries[k]] = v
    end
    data
  end

  def get_countries
    hash = {}
    Country.all.each { |country| hash[country.id] = country.name }
    hash
  end

end