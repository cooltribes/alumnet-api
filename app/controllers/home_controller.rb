class HomeController < ActionController::API

  #TODO Show more info
  def index
    render text: ""
  end

  def status
    if request.format == :json
      render json: { status: "ok" }
    else
      render text: "ok"
    end
  end

end