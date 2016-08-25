# config valid only for current version of Capistrano
lock '3.4.0'

set :application, 'nelou'
set :repo_url, 'git@github.com:sternzeit/nelou-reload.git'

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, '/home/deploy/apps/nelou'

# Default value for :scm is :git
set :scm, :git

# Default value for :format is :pretty
set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true
set :pty, false

# Default value for :linked_files is []
set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml')

# Default value for linked_dirs is []
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system', 'public/spree', 'tmp/mail', 'lib/invoices')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
set :keep_releases, 3

set :sidekiq_config, current_path.join('config', 'sidekiq.yml')

after 'deploy:publishing', 'deploy:restart'
after 'deploy:publishing', 'sidekiq:restart'

namespace :deface do
  desc "Pre-compile Deface overrides into templates"
  task :precompile do
    on roles(:app) do
      within release_path do
        with rails_env: fetch(:rails_env), deface_enabled: true do
          execute :rake, 'deface:precompile'
        end
      end
    end
  end

  if Rake.application.tasks.collect(&:to_s).include?("rvm:hook")
    before :precompile, 'rvm:hook'
  end
end

after 'deploy:updated', 'deface:precompile'

namespace :deploy do

  task :restart do
    invoke 'unicorn:legacy_restart'
  end

  task :seed do
    on roles(:db) do
      run "cd #{current_path}; bundle exec rake db:seed RAILS_ENV=#{fetch(:rails_env)}"
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
