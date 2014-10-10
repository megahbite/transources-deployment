# config valid only for Capistrano 3.1
lock '3.2.1'

set :application, 'transhealthdirectory'
set :repo_url, 'https://github.com/megahbite/transources.git'

set :branch, "master"
set :user, "deploy"

set :deploy_to, "/home/#{fetch(:user)}/#{fetch(:application)}"

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
set :linked_files, %w{config/database.yml config/local_env.yml}

# Default value for linked_dirs is []
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# Default value for default_env is {}
set :default_env, { path: "$HOME/.rbenv/shims:$HOME/.rbenv/bin:$PATH" }

# Default value for keep_releases is 5
set :keep_releases, 3

set :bundle_without, %w{development test}.join(" ")

set :rbenv_type, :user # or :system, depends on your rbenv setup
set :rbenv_ruby, '2.1.2'
#set :rbenv_custom_path, "/opt/rbenv"
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w{rake gem bundle ruby rails}
set :rbenv_roles, :all # default value

namespace :deploy do

  desc 'Start application'
  task :start do
    on roles(:app), in: :sequence, wait: 5 do
      within "#{release_path}" do
        execute :bundle, :exec, :unicorn, '-D', '-E', :production, "-c", "config/unicorn.rb"
      end
    end
  end

  desc 'Stop application'
  task :stop do
    on roles(:app), in: :sequence, wait: 5 do
      within "#{fetch(:deploy_to)}" do
        pid = capture(:cat, 'shared/tmp/pids/unicorn.pid')
        execute :kill, '-QUIT', pid
      end
    end
  end

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      within "#{fetch(:deploy_to)}" do
        pid = capture(:cat, 'shared/tmp/pids/unicorn.pid')
        execute :kill, '-USR2', pid
        # Your restart mechanism here, for example:
        # execute :touch, release_path.join('tmp/restart.txt')
      end
    end
  end

  after :publishing, :restart

end
