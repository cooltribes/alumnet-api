class V1::CountriesController < V1::BaseController
  before_action :set_country, except: [:index]

  def index
    @q = Country.search(params[:q])
    @countries = @q.result
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