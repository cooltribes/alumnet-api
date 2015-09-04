class V1::Business::LinksController < V1::BaseLinksController

  private

  def set_linkable
    @linkable = CompanyRelation.find(params[:business_id])
  end
end
