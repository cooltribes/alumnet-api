class V1::MetatagsController < V1::BaseController

  def index
    # TODO: code review :rafael
    webPage = Nokogiri::HTML(open(params[:url]))
    image = 'no image'
    if !webPage.css("meta[property='og:image']").blank?
      photo_url = webPage.css("meta[property='og:image']").first.attributes["content"]
      #image = URI.parse(photo_url)
      image = photo_url
    end
    description = 'no description'
    if !webPage.css("meta[property='og:description']").blank?
      description = webPage.css("meta[property='og:description']").first.attributes["content"]
    end
    title = 'no title'
    if !webPage.css("meta[property='og:title']").blank?
      title = webPage.css("meta[property='og:title']").first.attributes["content"]
    end

    msg = { :image => image.value, :description => description.value, :title => title.value }

    render json: msg
  end

  private
  def payment_params
    params.permit(:url)
  end
end