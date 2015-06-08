class V1::JobExchangesController < V1::TasksController

  def index
    @q = Task.job_exchanges.search(params[:q])
    @tasks = @q.result
  end

  private
    def help_type
      "task_job_exchange"
    end
end