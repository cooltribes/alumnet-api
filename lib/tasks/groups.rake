require 'rake'
namespace :groups do

  desc "send email digest"
  task send_digest: :environment do
    Group.all.each do |group|
      puts group.name
      group.email_digest()
    end
  end
end