class V1::MetatagsController < V1::BaseController

  def index
    metadata = MetaTagExtractor.new(url: params[:url])
    render json: { image: metadata.image, description: metadata.description, title: metadata.title }
  end

end