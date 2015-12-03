class V1::CountriesController < V1::BaseController
  before_action :set_country, except: [:index, :city]

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

  def show
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