lock '3.11.0'
set :application, "#{Settings.config.application}"
set :repo_url, Rails.application.credentials.deploy[:repo_url]
set :deploy_to, "/home/#{Settings.config.application}"
# set :pty, true
set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'puma.rb')
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'tmp/sessions', 'tmp/state', 'vendor/bundle', 'public/system', 'private/files')
set :tmp_dir, "/home/#{Settings.config.application}/shared/tmp"

set :keep_releases, 5

# after 'deploy:finishing',     'deploy:cleanup'
# before 'deploy:log_revision', 'puma:restart'