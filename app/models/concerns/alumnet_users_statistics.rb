class AlumnetUsersStatistics
  attr_accessor :user

  def initialize(user)
    @user = user
  end

  def per_type_of_membership(init_date, end_date, interval)
    alumni   = group_and_count_regular_users(init_date, end_date, interval)
    members  = group_and_count_members(init_date, end_date, interval)
    lifetime = group_and_count_lifetime(init_date, end_date, interval)
    format_for_line_graph [alumni, members, lifetime], interval
  end

  ## QUERYS

  def group_and_count_regular_users(init_date, end_date, interval)
    group_and_count_users query_for_regular_users(init_date, end_date), interval
  end

  def group_and_count_members(init_date, end_date, interval)
    group_and_count_subscriptions query_for_members(init_date, end_date), interval
  end

  def group_and_count_lifetime(init_date, end_date, interval)
    group_and_count_subscriptions query_for_lifetime(init_date, end_date), interval
  end

  def query_for_regular_users(init_date, end_date)
    User.where("date(active_at) between ? and ?", init_date, end_date).
      where(status: 1, member: 0).
      where(role: User::ROLES[:regular])
  end

  def query_for_admin_users(init_date, end_date)
    User.where("date(active_at) between ? and ?", init_date, end_date).
      where(status: 1, member: 0).
      where.not.(role: User::ROLES[:regular])
  end

  def query_for_alumni(init_date, end_date)
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

  ### HELPERS

  def format_for_line_graph(data_array, interval)
    data = []
    data << [interval.capitalize, "Alumni", "Members", "LT Members"]
    alumni, members, lifetime = data_array[0], data_array[1], data_array[2]
    keys = (alumni.keys + members.keys + lifetime.keys).uniq
    keys.each do |key|
      data << [key, alumni[key] || 0, members[key] || 0, lifetime[key] || 0]
    end
    data
  end

  private

  def total_from_hash(hash)
    hash.values.reduce(:+)
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

end