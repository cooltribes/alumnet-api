class Banner < ActiveRecord::Base
  
  mount_uploader :picture, PictureUploader

  ### Relations
  

  ### Callbacks
    def save_banner_in_album
      if cover_changed?
        album = albums.create_with(name: 'banners').find_or_create_by(album_type: Album::TYPES[:banner])
        picture = Picture.new(uploader: banner_uploader)
        picture.picture = banner
        album.pictures << picture
      end
    end

end
