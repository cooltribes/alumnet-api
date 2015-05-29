class Banner < ActiveRecord::Base
  
  mount_uploader :picture, PictureUploader
  
  def assign_order_to_banner
  	
  end			
  ### Relations
  

  ### Callbacks
    

end

