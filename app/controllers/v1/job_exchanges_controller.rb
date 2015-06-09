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

  private
    def help_type
      "task_job_exchange"
    end
end