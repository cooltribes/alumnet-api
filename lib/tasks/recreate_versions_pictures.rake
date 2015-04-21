require 'rake'
namespace :app do
  desc "recreate version of pictures of all models with carrierwave"
  task recreate_version_pictures: :environment do
    Event.all.each do |event|
      event.cover.recreate_versions!
      event.save!
    end
    Group.all.each do |group|
      group.cover.recreate_versions!
      group.save!
    end
    Picture.all.each do |picture|
      picture.picture.recreate_versions!
      picture.save!
    end
    Profile.all.each do |profile|
      profile.cover.recreate_versions!
      profile.save!
      profile.avatar.recreate_versions!
      profile.save!
    end
  end
end