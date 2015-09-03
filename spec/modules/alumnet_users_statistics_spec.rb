require 'rails_helper'

RSpec.describe AlumnetUsersStatistics, type: :stats, slow: true do

  describe "#group_and_count_registrants(init_date, end_date, interval)" do
    it "return all regular active user between the dates given" do
      user = make_regional_admin
      user.admin_location.countries.each do |c|
        2.times { make_lifetime_active_user(c, Date.parse('21-08-2010')) }
        2.times { make_regular_active_user(c, Date.parse('10-08-2010')) }
        1.times { make_regular_active_user(c, Date.parse('17-10-2010')) }
        2.times { make_regular_active_user(c, Date.parse('22-02-2011')) }
        2.times { make_regular_active_user(c, Date.parse('02-10-2013')) }
      end
      stats = AlumnetUsersStatistics.new(user)
      init_date = Date.parse('01-01-2010')
      end_date = Date.parse('31-12-2013')
      expect(stats.group_and_count_registrants(init_date, end_date, "years")).to eq(
        { "2010" =>  12, "2011" => 8, "2013" => 8})
      expect(stats.group_and_count_registrants(init_date, end_date, "days")).to eq(
        { "10-08-2010" => 8, "17-10-2010" => 4, "22-02-2011" => 8, "02-10-2013" => 8})
      expect(stats.group_and_count_registrants(init_date, end_date, "months")).to eq(
        { "08-2010" => 8, "10-2010" => 4, "02-2011" => 8, "10-2013" => 8})
    end
  end

  describe "#group_and_count_lifetime(init_date, end_date, interval)" do
    it "return all lifetime active user between the dates given" do
      user = make_regional_admin
      user.admin_location.countries.each do |c|
        2.times { make_regular_active_user(c, Date.parse('10-08-2010')) }
        2.times { make_lifetime_active_user(c, Date.parse('21-08-2010')) }
        2.times { make_lifetime_active_user(c, Date.parse('26-10-2010')) }
        2.times { make_lifetime_active_user(c, Date.parse('05-05-2011')) }
        2.times { make_lifetime_active_user(c, Date.parse('10-10-2013')) }
      end
      stats = AlumnetUsersStatistics.new(user)
      init_date = Date.parse('01-01-2010')
      end_date = Date.parse('31-12-2013')
      expect(stats.group_and_count_lifetime(init_date, end_date, "years")).to eq(
        { "2010" =>  16, "2011" => 8, "2013" => 8})
      expect(stats.group_and_count_lifetime(init_date, end_date, "days")).to eq(
        { "21-08-2010" => 8, "26-10-2010" => 8, "05-05-2011" => 8, "10-10-2013" => 8})
      expect(stats.group_and_count_lifetime(init_date, end_date, "months")).to eq(
        { "08-2010" => 8, "10-2010" => 8, "05-2011" => 8, "10-2013" => 8})
    end
  end

  describe "#group_and_count_members(init_date, end_date, interval)" do
    it "return all member active user between the dates given" do
      user = make_regional_admin
      user.admin_location.countries.each do |c|
        2.times { make_lifetime_active_user(c, Date.parse('21-08-2010')) }
        2.times { make_member_active_user(c, Date.parse('21-08-2010')) }
        2.times { make_member_active_user(c, Date.parse('26-10-2010')) }
        2.times { make_member_active_user(c, Date.parse('05-05-2011')) }
        2.times { make_member_active_user(c, Date.parse('10-10-2013')) }
      end
      stats = AlumnetUsersStatistics.new(user)
      init_date = Date.parse('01-01-2010')
      end_date = Date.parse('31-12-2013')
      expect(stats.group_and_count_members(init_date, end_date, "years")).to eq(
        { "2010" =>  16, "2011" => 8, "2013" => 8})
      expect(stats.group_and_count_members(init_date, end_date, "days")).to eq(
        { "21-08-2010" => 8, "26-10-2010" => 8, "05-05-2011" => 8, "10-10-2013" => 8})
      expect(stats.group_and_count_members(init_date, end_date, "months")).to eq(
        { "08-2010" => 8, "10-2010" => 8, "05-2011" => 8, "10-2013" => 8})
    end
  end

  describe "#format_for_line_graph(data_array, interval)" do
    it "convert the hash data in to array for google graph" do
      user = make_regional_admin
      stats = AlumnetUsersStatistics.new(user)
      data_array = [200, 100, 50]
      expect(stats.format_for_pie_graph(data_array)).to eq([
        ['Users', 'Count'],
        ['Registrants', 200],
        ['Members', 100],
        ['LT Members', 50],
      ])
    end
  end

  describe "#format_for_line_graph(data_array, interval)" do
    it "convert the hash data in to array for google graph" do
      user = make_regional_admin
      regulars = { "2010"=> 10, "2011"=> 40, "2012"=>10, "2013"=>60 }
      members = {  "2011"=> 80, "2012"=>20, "2013"=>30 }
      lifetime = { "2010"=> 14, "2011"=> 55, "2012"=>33, "2013"=>27, "2014"=>100 }
      stats = AlumnetUsersStatistics.new(user)
      data_array = [regulars, members, lifetime]
      expect(stats.format_for_line_graph(data_array, "years")).to eq([
        ['Years', 'Registrants', 'Members', 'LT Members'],
        ['2010', 10, 0, 14],
        ['2011', 40, 80, 55],
        ['2012', 10, 20, 33],
        ['2013', 60, 30, 27],
        ['2014', 0, 0, 100],
      ])
    end

    # it {
    #   user = make_regional_admin
    #   user.admin_location.countries.each do |c|
    #     1.times { make_lifetime_active_user(c, Date.parse('21-08-2010')) }
    #     1.times { make_lifetime_active_user(c, Date.parse('11-05-2010')) }
    #     2.times { make_member_active_user(c, Date.parse('26-05-2010')) }
    #     2.times { make_member_active_user(c, Date.parse('05-05-2011')) }
    #     2.times { make_regular_active_user(c, Date.parse('10-10-2013')) }
    #     2.times { make_regular_active_user(c, Date.parse('02-11-2015')) }
    #   end
    #   stats = AlumnetUsersStatistics.new(user)
    #   init_date = Date.parse('01-01-2010')
    #   end_date = Date.parse('31-12-2015')
    #   expect(stats.per_type_of_membership(init_date, end_date, 'days')).to eq([])
    # }
  end

  describe "#group_and_count_users_by_country(type_users, init_date, end_date)" do
    context "with local admin" do
      it "return all active users group by residence country and type of users" do
        init_date = Date.parse('01-01-2010')
        end_date = Date.parse('31-12-2013')
        local_admin = make_local_admin("Venezuela")
        3.times { make_regular_active_user(local_admin.admin_location, Date.parse('21-08-2010')) }
        stats = AlumnetUsersStatistics.new(local_admin)
        expect(stats.group_and_count_users_by_country("registrants", init_date, end_date)).to eq({"Venezuela"=>3})
      end
    end

    context "regional admin" do
      it "return all active users group by residence country and type of users" do
        init_date = Date.parse('01-01-2010')
        end_date = Date.parse('31-12-2013')
        regional_admin = make_regional_admin
        regional_admin.admin_location.countries.each do |c|
          2.times { make_lifetime_active_user(c, Date.parse('21-08-2010')) }
          2.times { make_regular_active_user(c, Date.parse('10-08-2010')) }
          1.times { make_regular_active_user(c, Date.parse('17-10-2010')) }
          2.times { make_regular_active_user(c, Date.parse('22-02-2011')) }
          2.times { make_regular_active_user(c, Date.parse('02-10-2013')) }
        end
        stats = AlumnetUsersStatistics.new(regional_admin)
        expect(stats.group_and_count_users_by_country("registrants", init_date, end_date)).to eq(
          "Venezuela" => 7, "Colombia" => 7, "Chile" => 7, "Ecuador" => 7)
      end
    end
  end

  describe "#group_and_count_users_by_region(type_users, init_date, end_date)" do
    context "super admin" do
      it "return all active user group by region and type of users" do
        init_date = Date.parse('01-01-2010')
        end_date = Date.parse('31-12-2013')
        super_admin = User.make!(:admin)
        regions = []
        ["America", "Europe", "Asia"].each { |name| regions << Region.make!(name: name) }
        regions.each do |region|
          3.times { region.countries << Country.make!(:simple) }
        end
        regions.each do |region|
          region.countries.each do |c|
            1.times { make_regular_active_user(c, Date.parse('17-10-2010')) }
            1.times { make_regular_active_user(c, Date.parse('26-08-2012')) }
          end
        end
        stats = AlumnetUsersStatistics.new(super_admin)
        expect(stats.group_and_count_users_by_region("registrants", init_date, end_date)).to eq(
          {"America"=>6, "Europe"=>6, "Asia"=>6})
        # expect(stats.per_country_and_region("2010-01-01", "2012-12-31", "regions")).to eq("")
      end
    end
  end

  describe "#group_and_count_users_by_senority()" do
    context "super admin" do
      it "return all active user group by seniority of current profesional experience" do
        super_admin = User.make!(:admin)
        3.times do
          country = Country.make!(:simple)
          seniority = Seniority.make!
          2.times do
            user = make_regular_active_user(country, Date.parse('17-10-2010'))
            Experience.make!(:profesional, profile: user.profile, current: true, seniority: seniority)
          end
        end
        stats = AlumnetUsersStatistics.new(super_admin)
        expect(stats.group_and_count_users_by_seniority).to eq(
          {"Seniority 0001"=>2, "Seniority 0002"=>2, "Seniority 0003"=>2})
        # expect(stats.per_country_and_region("2010-01-01", "2012-12-31", "regions")).to eq("")
      end
    end
  end
end