set :output, {
    :error    => "#{path}/log/error.log",
    :standard => "#{path}/log/cron.log"
}

every 1.day, :at => '1:30 am' do
  rake "subscriptions:validate_users_membership"
end