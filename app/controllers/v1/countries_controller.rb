class V1::CountriesController < V1::BaseController
  before_action :set_country, except: [:index, :city, :locations]

  def index
    ## Too dirty!
    if params[:committee_type]
      cc_fips = Committee.where(committee_type: params[:committee_type]).pluck(:cc_fips).uniq
      @countries = Country.where(cc_fips: cc_fips)
    else
      @q = Country.ransack(params[:q])
      @countries = @q.result
    end
  end

  def locations
    @locations = ::Global::SearchLocation.new(params[:q]).call
  end

  def show
  end

  def alumni
    region = @country.region
    in_region_count = region.try(:users).try(:count)
    render json: { in_country: @country.users.count, in_region: in_region_count, total: User.count }
  end

  def cities
    @q = @country.cities.ransack(params[:q])
    @cities = @q.result.order(name: :asc)
  end

  def committees
    other_committee = Committee.find_by(name: "Other")
    @q = @country.committees.ransack(params[:q])
    @committees = @q.result | [other_committee]
    @committees = @committees.sort_by(&:name)
  end

  private
    def set_country
      @country = Country.find(params[:id])
    end
end