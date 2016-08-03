set :output, "#{path}/log/cron.log"

#job_type for rake task of elasticsearch in production and staging
job_type :elasticsearch, "cd :path && :environment_variable=:environment FORCE=true bundle exec rake environment :task --silent :output"

every 1.day, at: '2:30 am' do
  elasticsearch "elasticsearch:import:all"
  rake "subscriptions:validate_users_membership"
  rake "app:destroy_orphan_files"
end

every 1.day, at: '11:30 am' do
  rake "admin_users:new_registrations_digest"
end