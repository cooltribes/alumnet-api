class V1::MeetupExchangesController < V1::TasksController

  def index
    @q = Task.meetup_exchanges.current.ransack(params[:q])
    @tasks = @q.result
    render 'v1/tasks/index'
  end

  def my
    @q = current_user.tasks.meetup_exchanges.ransack(params[:q])
    @tasks = @q.result
    render 'v1/tasks/index'
  end

  def applied
    @q = Task.applied_by(current_user).meetup_exchanges.ransack(params[:q])
    @tasks = @q.result
    render 'v1/tasks/index'
  end

  def apply
    if @task.can_apply(current_user)
      @task.apply(current_user)
      render 'v1/tasks/show'
    else
      render json: { error: "The user can not apply to the task" }, status: :unprocessable_entity
    end
  end

  private
    def help_type
      "task_meetup_exchange"
    end

    def task_params
      params.permit(:name, :description, :formatted_description, :must_have_list,
        :nice_have_list, :post_until, :arrival_date)
    end
end