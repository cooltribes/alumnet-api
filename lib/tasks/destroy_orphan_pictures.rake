require 'rake'
namespace :app do
  desc "destroy all files without a pictureable id and album id"
  task destroy_orphan_files: :environment do
    Picture.where(album_id: nil, pictureable_id: nil).destroy_all
  end
end