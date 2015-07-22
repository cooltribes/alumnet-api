class V1::Admin::StatsController < V1::AdminController
  before_action :set_stats
  before_action :set_dates

  def type_of_membership
    graphs_info = @stats.per_type_of_membership(@init_date, @end_date, params[:interval])
    render json: graphs_info
  end

  def country_and_region
    graphs_info = @stats.per_country_and_region(@init_date, @end_date, params[:geo])
    render json: graphs_info
  end


  private
    def set_stats
      @stats = AlumnetUsersStatistics.new(current_user)
    end

    def set_dates
      @init_date = params[:init_date]
      @end_date = params[:end_date]
    end

end
