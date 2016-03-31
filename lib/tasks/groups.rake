require 'rake'
namespace :groups do

  desc "send email digest"
  task send_digest: :environment do
    Group.all.each do |group|
      puts group.name
      if group.posts.count > 0
        group.email_digest()
      else
        puts '-- Not enough posts'
      end
    end
  end
end