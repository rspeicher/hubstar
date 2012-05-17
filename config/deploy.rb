set :user,        "tsigo"
set :application, "hubstar"
set :deploy_to,   "/var/www/rails/#{application}"
set :rails_env,   "production"

set :domain,      "tsigo.com"
set :repository,  "git@github.com:#{user}/#{application}.git"
set :scm,         'git'
set :branch,      'master'

set :use_sudo, false
set :keep_releases, 3

set :ssh_options, { forward_agent: true, keys: "~/.ssh/id_rsa" }

set :normalize_asset_timestamps, false

role :app, domain
role :web, domain
role :db,  domain, primary: true

require 'bundler/capistrano'

namespace :rails do
  desc "Copy shared configuration files"
  task :copy_shared, roles: :app do
    run "cp #{shared_path}/config/database.yml #{current_release}/config/database.yml"
    run "cp #{shared_path}/config/heroku_env.rb #{current_release}/config/heroku_env.rb"
  end

  desc 'Restart server'
  task :restart, roles: :app do
    run "touch #{current_release}/tmp/restart.txt"
  end
end

after "deploy:update_code", "rails:copy_shared"
before "deploy:restart",    "rails:restart"

after "deploy", "deploy:cleanup"
