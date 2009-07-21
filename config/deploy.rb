require 'lib/cap_recipes'

set :application, "movierok"
set :deploy_to, "/srv/web/#{application}"
server "88.198.204.146", :app, :web, :db, :primary => true
set :user, "deployer"
set :use_sudo, false
ssh_options[:port] = 1337
ssh_options[:forward_agent] = true

#############################################################
#	GIT
#############################################################

set :scm, :git
set :repository, "git@github.com:mino/movierok.org.git"
set :branch, "master"
set :deploy_via, :remote_cache
default_run_options[:pty] = true
