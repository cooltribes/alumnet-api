class V1::JobExchangesController < V1::TasksController

  def index
    @q = Task.job_exchanges.search(params[:q])
    @tasks = @q.result
    render 'v1/tasks/index'
  end

  def my
    @q = current_user.tasks.job_exchanges.search(params[:q])
    @tasks = @q.result
    render 'v1/tasks/index'
  end

  def applied
    @q = Task.applied_by(current_user).job_exchanges.search(params[:q])
    @tasks = @q.result
    render 'v1/tasks/index'
  end

  private
    def help_type
      "task_job_exchange"
    end

    def task_params
      params.permit(:name, :description, :formatted_description, :must_have_list, :nice_have_list,
        :company_id, :city_id, :country_id, :offer, :employment_type, :seniority_id)
    end
end