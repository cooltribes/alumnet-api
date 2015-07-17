require 'rails_helper'

describe V1::Admin::RegionsController, type: [:request, :stats] do
  let!(:current_user) { User.make!(:admin) }

  describe "GET /admin/stats/type_of_membership" do
    it "return the data for the line and pie graph of the dashboard" do
      user = make_regional_admin
      user.admin_location.countries.each do |c|
        1.times { make_lifetime_active_user(c, Date.parse('21-08-2010')) }
        1.times { make_member_active_user(c, Date.parse('05-05-2011')) }
        1.times { make_regular_active_user(c, Date.parse('02-11-2015')) }
      end
      params = { init_date: "2010-01-01", end_date: "2015-12-31", interval: "years"}
      get admin_stats_type_of_membership_path, params, basic_header(current_user.auth_token)
      expect(response.status).to eq(200)
      # expect(json).to eq("")
    end
  end
end