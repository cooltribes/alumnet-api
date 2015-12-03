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

  def generation_and_gender
    graphs_info = @stats.per_generation_and_gender
    render json: graphs_info
  end

  def seniorities
    graphs_info = @stats.per_seniorities
    render json: graphs_info
  end

  def status
    graphs_info = @stats.per_status
    render json: graphs_info
  end

  def posts_stats
    stats = AlumnetPostsStatistics.new(@init_date, @end_date, params[:group_by])
    render json: stats.get_data
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
