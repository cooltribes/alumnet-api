class V1::JobExchangesController < V1::TasksController

  def index
    @q = Task.job_exchanges.search(params[:q])
    @tasks = @q.result
    if @tasks.class == Array
      @tasks = Kaminari.paginate_array(@tasks).page(params[:page]).per(params[:per_page]) 
    else
      @tasks = @tasks.page(params[:page]).per(params[:per_page]) # if @posts is AR::Relation object 
    end    
    render 'v1/tasks/index'
  end

  def my
    @q = current_user.tasks.job_exchanges.search(params[:q])
    @tasks = @q.result
    if @tasks.class == Array
      @tasks = Kaminari.paginate_array(@tasks).page(params[:page]).per(params[:per_page]) 
    else
      @tasks = @tasks.page(params[:page]).per(params[:per_page]) # if @posts is AR::Relation object 
    end     
    render 'v1/tasks/index'
  end

  def apply
    if @task.can_apply(current_user)
      @task.apply(current_user)
      UserMailer.user_applied_to_job(@task, current_user, apply_params["whyme"]).deliver_now

      render 'v1/tasks/show'
    else
      render json: { error: "The user can not apply to the task" }, status: :unprocessable_entity
    end
  end

  def applied
    @q = Task.applied_by(current_user).job_exchanges.search(params[:q])
    @tasks = @q.result
    if @tasks.class == Array
      @tasks = Kaminari.paginate_array(@tasks).page(params[:page]).per(params[:per_page]) 
    else
      @tasks = @tasks.page(params[:page]).per(params[:per_page]) # if @posts is AR::Relation object 
    end     
    render 'v1/tasks/index'
  end

  private
    def help_type
      "task_job_exchange"
    end

    def task_params
      params.permit(:name, :description, :formatted_description, :must_have_list, :nice_have_list,
        :company_id, :city_id, :country_id, :offer, :employment_type, :seniority_id, :application_type, :external_url)
    end
    def apply_params
      params.permit(:whyme)
    end
end