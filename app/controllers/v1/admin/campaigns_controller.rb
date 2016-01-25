class V1::Admin::CampaignsController < V1::AdminController

  def index
    @q = Campaign.ransack(params[:q])
    @campaigns = @q.result
  end

  def show
  end
end