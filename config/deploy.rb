# config valid only for current version of Capistrano
lock '3.4.0'

set :application, 'alumnet-api'
set :repo_url, 'https://ArmandoMendoza:Geforce9800gtx@github.com/cooltribes/alumnet-api.git '#'git@github.com:cooltribes/alumnet-api.git'
set :scm, :git
set :linked_files, %w{config/database.yml config/application.yml}
set :linked_dirs, %w{public/uploads}

# Rollbar integration
set :rollbar_token, 'ff2f3b4759d746b9b955259ab820144e'
set :rollbar_env, Proc.new { fetch :stage }
set :rollbar_role, Proc.new { :app }
set :whenever_identifier, ->{ "#{fetch(:application)}_#{fetch(:stage)}" }

# there is a known bug that prevents sidekiq from starting when pty is true on Capistrano 3.

# set :nginx_sudo_tasks, ['nginx:restart', 'nginx:configtest']
# set :pty, true


# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

# Default deploy_to directory is /var/www/my_app_name

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false

# Default value for :linked_files is []
# set :linked_files, fetch(:linked_files, []).push('config/database.yml')

# Default value for linked_dirs is []
# set :linked_dirs, fetch(:linked_dirs, []).push('bin', 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

namespace :deploy do

  after :finished, :create_secrets do
    on roles(:all) do
      within current_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, "app:create_secret_file"
        end
      end
    end
  end

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

end
