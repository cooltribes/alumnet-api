class V1::CitiesController < V1::BaseController
  before_action :set_city

  def show
  end

  private
    def set_city
      @city = City.find(params[:id])
    end
end