class V1::Companies::LinksController < V1::BaseLinksController

  private

  def set_linkable
    @linkable = Company.find(params[:company_id])
  end
end
