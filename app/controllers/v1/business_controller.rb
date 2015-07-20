class V1::BusinessController < V1::BaseController

  def index
    @q = CompanyRelation.search(params[:q])
    @companies = @q.result.limit(params[:limit])
    render 'v1/users/business/index'
  end

end
