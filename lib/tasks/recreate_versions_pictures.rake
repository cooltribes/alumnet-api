require 'rake'
namespace :app do
  desc "recreate version of pictures of all models with carrierwave"
  task recreate_version_pictures: :environment do
    Event.all.each do |event|
      if event.cover?
        event.cover.recreate_versions!
        event.save!
      end
    end
    Group.all.each do |group|
      if group.cover?
        group.cover.recreate_versions!
        group.save!
      end
    end
    Picture.all.each do |picture|
      if picture.picture?
        picture.picture.recreate_versions!
        picture.save!
      end
    end
    Profile.all.each do |profile|
      if profile.cover? && profile.approval?
        profile.cover.recreate_versions!
        profile.save!
      end
      if profile.avatar? && profile.approval?
        profile.avatar.recreate_versions!
        profile.save!
      end
    end
  end
end