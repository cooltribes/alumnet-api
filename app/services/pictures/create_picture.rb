module Pictures
  class CreatePicture

    attr_reader :pictureable, :picture, :errors

    def initialize(pictureable, current_user, params)
      @pictureable = pictureable
      @current_user = current_user
      @params = params
    end

    def call
      @picture = Picture.new(picture: @params[:file])
      @picture.uploader = @current_user
      if @pictureable.pictures << @picture
        true
      else
        @errors = @comment.errors
        false
      end
    end
  end
end