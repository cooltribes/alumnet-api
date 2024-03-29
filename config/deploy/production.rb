server 'alumnet-test.aiesec-alumni.org',
  roles: %w{web app db},
  ssh_options: {
    user: 'ec2-user',
    keys: %w(~/alumnet.pem),
    forward_agent: true,
    auth_methods: %w(publickey)
  }
set :deploy_to, '/home/ec2-user/alumnet_production/alumnet-api'
set :branch, 'master'

#### Sidekiq options for capistrano-sidekiq
set :sidekiq_queue, ['profinda', 'mailers', 'pusher', 'rollbar', 'indexer']

# Custom SSH Options
# ==================
# You may pass any option but keep in mind that net/ssh understands a
# limited set of options, consult[net/ssh documentation](http://net-ssh.github.io/net-ssh/classes/Net/SSH.html#method-c-start).
#
# Global options
# --------------
#  set :ssh_options, {
#    keys: %w(/home/rlisowski/.ssh/id_rsa),
#    forward_agent: false,
#    auth_methods: %w(password)
#  }
#
# And/or per server (overrides global)
# ------------------------------------
# server 'example.com',
#   user: 'user_name',
#   roles: %w{web app},
#   ssh_options: {
#     user: 'user_name', # overrides user setting above
#     keys: %w(/home/user_name/.ssh/id_rsa),
#     forward_agent: false,
#     auth_methods: %w(publickey password)
#     # password: 'please use keys'
#   }
