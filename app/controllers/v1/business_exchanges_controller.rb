class V1::BusinessExchangesController < V1::TasksController

  def index
    @q = Task.business_exchanges.ransack(params[:q])
    @tasks = @q.result
    if @tasks.class == Array
      @tasks = Kaminari.paginate_array(@tasks).page(params[:page]).per(params[:per_page])
    else
      @tasks = @tasks.page(params[:page]).per(params[:per_page]) # if @posts is AR::Relation object
    end
    #@tasks = @q.result.limit(params[:limit])
    render 'v1/tasks/index'
  end

  def my
    @q = current_user.tasks.business_exchanges.ransack(params[:q])
    @tasks = @q.result
    render 'v1/tasks/index'
  end

  def applied
    @q = Task.applied_by(current_user).business_exchanges.ransack(params[:q])
    @tasks = @q.result
    render 'v1/tasks/index'
  end

  private
    def help_type
      "task_business_exchange"
    end

    def task_params
      params.permit(:name, :description, :formatted_description, :must_have_list,
        :nice_have_list, :post_until)
    end
end