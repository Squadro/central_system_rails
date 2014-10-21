require "bundler/capistrano"
require "rvm/capistrano"
require 'capistrano/sidekiq'

server "128.199.132.64", :web, :app, :db, primary: true

set :application, "predicta"
set :user, "anil"
set :port, 8617 #your ssh port
set :deploy_to, "/home/#{user}/apps/#{application}"
set :deploy_via, :remote_cache
set :use_sudo, false

set :scm, "git"
set :repository, "git@github.com:Squadro/central_system_rails.git" #your application repo (for instance git@github.com:user/application.git)
set :scm_username, "anilbhandary"
set :scm_prefer_prompt, :true
set :scm_verbose, :true
set :branch, "master"


set :rvm_ruby_string, :local              # use the same ruby as used locally for deployment
set :rvm_autolibs_flag, "read-only"       # more info: rvm help autolibs

#before 'deploy:setup', 'rvm:install_rvm'  # install/update RVM
# before 'deploy:setup', 'rvm:install_ruby' # install Ruby and create gemset, OR:
# before 'deploy:setup', 'rvm:create_gemset' # only create gemset

default_run_options[:pty] = true
ssh_options[:forward_agent] = true

after "deploy", "deploy:cleanup" # keep only the last 5 releases

namespace :deploy do
  %w[start stop restart].each do |command|
    desc "#{command} unicorn server"
    task command, roles: :app, except: { no_release: true } do
      run "/etc/init.d/unicorn_#{application} #{command}"
    end
  end

  task :setup_config, roles: :app do
    # symlink the unicorn init file in /etc/init.d/
    sudo "ln -nfs #{current_path}/config/unicorn_init.sh /etc/init.d/unicorn_#{application}"
    # create a shared directory to keep files that are not in git and that are used for the application
    run "mkdir -p #{shared_path}/config"
    # if you're using mongoid, create a mongoid.template.yml file and fill it with your production configuration
    # and add your mongoid.yml file to .gitignore
    put File.read("config/mongoid.yml"), "#{shared_path}/config/mongoid.yml"
    puts "Now edit the config files in #{shared_path}."
  end
  after "deploy:setup", "deploy:setup_config"

  task :symlink_config, roles: :app do
    # symlink the shared mongoid config file in the current release
    run "ln -nfs #{shared_path}/config/mongoid.yml #{release_path}/config/mongoid.yml"
  end
  after "deploy:finalize_update", "deploy:symlink_config"

  desc "Create MongoDB indexes"
  task :mongoid_indexes do
    run "cd #{current_path} && RAILS_ENV=production bundle exec rake db:mongoid:create_indexes", once: true
  end
  after "deploy:update", "deploy:mongoid_indexes"

  desc "Make sure local git is in sync with remote."
  task :check_revision, roles: :web do
    unless `git rev-parse HEAD` == `git rev-parse origin/master`
      puts "WARNING: HEAD is not the same as origin/master"
      puts "Run `git push` to sync changes."
      exit
    end
  end
  before "deploy", "deploy:check_revision"
end
