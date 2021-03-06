# config valid only for current version of Capistrano
lock '3.4.0'

set :application, 'terappel'
set :deploy_user, 'centos'
set :repo_url, 'git@github.com:afcrpv/terappel.git'

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name

# rbenv config
set :rbenv_type, :user # or :system, depends on your rbenv setup
set :rbenv_ruby, '2.3.0'
set :rbenv_prefix,
    "RBENV_ROOT=#{fetch(:rbenv_path)}
     RBENV_VERSION=#{fetch(:rbenv_ruby)}
     #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w(rake gem bundle ruby rails)
set :rbenv_roles, :all # default value

# puma config
set :nginx_config_name, "#{fetch(:application)}_#{fetch(:stage)}.conf"
set :nginx_sites_available_path, "/home/#{fetch(:deploy_user)}/apps"
set :nginx_sites_enabled_path, "/home/#{fetch(:deploy_user)}/apps"
set :puma_init_active_record, true

# bundler
set :bundle_flags, '--deployment'

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
set :pty, true

# Default value for :linked_files is []
set :linked_files, fetch(:linked_files, []).push(
  'config/database.yml', 'config/application.yml', 'config/puma.rb')

# Default value for linked_dirs is []
set :linked_dirs, fetch(:linked_dirs, []).push(
  'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle',
  'public/system', 'csv')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

namespace :deploy do
  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end
end
