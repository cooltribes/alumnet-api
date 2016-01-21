require 'mailchimp'

class V1::Groups::CampaignsController < V1::BaseController
  before_action :set_group
  before_action :set_campaign, only: [:update, :destroy, :show]
  before_action :set_user, only: [:create, :send_test, :preview]
  before_action :create_campaign, only: [:create, :send_test, :preview]
  before_action :set_mailchimp

  def index
    @campaigns = @group.campaigns
  end

  def create
    if @group.mailchimp
      @campaign.status = :sent
      @campaign.list_id = @group.list_id
      if @campaign.save
        @response = @mailchimp.campaigns.create('regular', 
          {
            'list_id' => @group.list_id, 
            'subject' => @campaign.subject, 
            'from_email' => 'alumnet-noreply@aiesec-alumni.org',
            'from_name' => 'AlumNet',
            'to_name' => @group.name
          },
          {
            'html' => @campaign.body
          }
        )
        @campaign.update(provider_id: @response['id'])
        @mailchimp.campaigns.send(@campaign.provider_id)
        render :show, status: :created
      end
    else
      render json: @campaign.errors, status: :unprocessable_entity
    end
  end

  def send_test
    if @group.mailchimp
      @campaign.status = :saved
      @campaign.list_id = @group.list_id
      if @campaign.save
        @response = @mailchimp.campaigns.create('regular', 
          {
            'list_id' => @group.list_id, 
            'subject' => @campaign.subject, 
            'from_email' => 'alumnet-noreply@aiesec-alumni.org',
            'from_name' => 'AlumNet',
            'to_name' => @group.name
          },
          {
            'html' => @campaign.body
          }
        )
        @campaign.update(provider_id: @response['id'])
        @mailchimp.campaigns.send_test(@campaign.provider_id, [@user.email, 'yroa@upsidecorp.ch'])
        render :show, status: :created
      end
    else
      render json: @campaign.errors, status: :unprocessable_entity
    end
  end

  def preview
    if @group.mailchimp
      @campaign.status = :saved
      @campaign.list_id = @group.list_id
      if @campaign.save
        @response = @mailchimp.campaigns.create('regular', 
          {
            'list_id' => @group.list_id, 
            'subject' => @campaign.subject, 
            'from_email' => 'alumnet-noreply@aiesec-alumni.org',
            'from_name' => 'AlumNet',
            'to_name' => @group.name
          },
          {
            'html' => @campaign.body
          }
        )
        @campaign.update(provider_id: @response['id'])
        @preview = @mailchimp.campaigns.content(@campaign.provider_id, {'view' => 'preview'})
        @preview[:campaign] = @campaign
        render json: @preview, status: :created
      end
    else
      render json: @campaign.errors, status: :unprocessable_entity
    end
  end

  def show
    @response = @mailchimp.campaigns.list({'campaign_id' => @campaign.provider_id})
    render json: @response['data'][0]
  end

  private
    def set_group
      @group = Group.find(params[:group_id])
    end

    def set_campaign
      @campaign = @group.campaigns.find(params[:id])
    end

    def create_campaign
      if params[:provider_id]
        @campaign = @group.campaigns.find_by(provider_id: params[:provider_id])
        @campaign.attributes = campaign_params
      else
        @campaign = Campaign.new(campaign_params)
      end
    end

    def set_user
      unless @user = User.find_by(id: params[:user_id])
        render json: { error: "User not found" }
      end
    end

    def set_mailchimp
      if @group.mailchimp
        @mailchimp = Mailchimp::API.new(@group.api_key)
      else
        @mailchimp = nil
      end
    end

    def campaign_params
      params.permit(:user_id, :group_id, :subject, :body, :provider_id)
    end
end
