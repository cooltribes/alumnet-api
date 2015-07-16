class V1::Admin::StatsController < V1::AdminController
  before_action :set_stats
  before_action :set_dates

  def type_of_membership
    graphs_info = @stats.per_type_of_membership(@init_date, @end_date, @interval)
    render json: graphs_info
  end


  private
    def set_stats
      @stats = AlumnetUsersStatistics.new(current_user)
    end

    def set_dates
      @init_date = Date.parse(params[:init_date])
      @end_date = Date.parse(params[:end_date])
      @interval = params[:interval]
    end

end
