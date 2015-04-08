class V1::CountriesController < V1::BaseController
  before_action :set_country, except: [:index]

  def index
    ## Too dirty!
    if params[:committee_type]
      cc_fips = Committee.where(committee_type: params[:committee_type]).pluck(:cc_fips).uniq
      @countries = Country.where(cc_fips: cc_fips)
    else
      @q = Country.search(params[:q])
      @countries = @q.result
    end
  end

  def show
  end

  def cities
    @q = @country.cities.search(params[:q])
    @cities = @q.result
  end

  def committees
    @q = @country.committees.search(params[:q])
    @committees = @q.result
  end


  private
    def set_country
      @country = Country.find(params[:id])
    end
end