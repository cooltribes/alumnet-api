class V1::MetatagsController < V1::BaseController

  def index
    image = 'no image'
    if !Nokogiri::HTML(open(params[:url])).css("meta[property='og:image']").blank?
      photo_url = Nokogiri::HTML(open(params[:url])).css("meta[property='og:image']").first.attributes["content"]
      image = URI.parse(photo_url)
    end
    render plain: image
  end

  private
  def payment_params
    params.permit(:url)
  end
end