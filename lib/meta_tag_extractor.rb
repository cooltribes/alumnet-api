class MetaTagExtractor

  attr_reader :url, :image, :description, :title

  META_INFO = ["image", "description", "title"]

  def initialize(url: url)
    # TODO: validate url
    @url = url.strip
    # TODO: Preguntar si esto es necesario en ui o se puede enviar un nil :rafael
    @image = "no image"
    @description = "no description"
    @title = "no title"
    run
  end


  def webpage
    @webpage ||= begin
      Nokogiri::HTML(open(url))
    rescue
      nil
    end
  end


  private
    def run
      extract_image
      extract_description
      extract_title
    end

    META_INFO.each do |info|
      define_method("extract_#{info}") do
        return if webpage.nil?
        meta = webpage.css("meta[property='og:#{info}']")
        instance_variable_set("@#{info}", meta.first.attributes["content"].try(:value)) if meta.present?
      end
    end

end