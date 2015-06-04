class V1::TasksController < V1::BaseController
  include Pundit
  before_action :set_task, except: [:index, :create]

  def index
    @q = Task.search(params[:q])
    @tasks = @q.result
    render 'v1/tasks/index'
  end

  def show
    render 'v1/tasks/show'
  end

  def create
    @task = Task.new(task_params)
    @task.help_type = help_type
    if current_user.tasks << @task
      @task.create_profinda_task
      render 'v1/tasks/show', status: :created
    else
      render json: @task.errors, status: :unprocessable_entity
    end
  end

  def update
    if @task.update(task_params)
      @task.update_profinda_task
      render 'v1/tasks/show'
    else
      render json: @task.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @task.destroy
    head :no_content
  end

  private

    def help_type
    end

    def set_task
      @task = Task.find(params[:id])
    end

    def task_params
      params.permit(:name, :description, :duration, :post_until, :must_have_list,
       :nice_have_list, :company_id, :city_id, :country_id, :offer)
    end

end