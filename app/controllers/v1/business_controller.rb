class V1::BusinessController < V1::BaseController

  def index
    @q = CompanyRelation.ransack(params[:q])

    @companies = @q.result
    if @companies.class == Array
      @companies = Kaminari.paginate_array(@companies).page(params[:page]).per(params[:per_page])
    else
      @companies = @companies.page(params[:page]).per(params[:per_page]) # if @posts is AR::Relation object
    end

    #@companies = @q.result.limit(params[:limit])
    render 'v1/users/business/index'
  end

end
