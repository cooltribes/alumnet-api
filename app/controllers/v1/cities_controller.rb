class V1::CitiesController < V1::BaseController
  before_action :set_city, except: [:index]

  def index
    query = { name_cont: params[:q], country_name_cont: params[:q], m: "or" }
    @cities = City.ransack(query).result
  end

  def show
  end

  private
    def set_city
      @city = City.find(params[:id])
    end
end