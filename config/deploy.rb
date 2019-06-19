lock '3.11.0'
set :application, "progettilab"
set :repo_url, "git@github.com:isprambiente/progettilab.git"
set :deploy_to, "/home/progettilab"
# set :pty, true
set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'puma.rb')
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'tmp/sessions', 'tmp/state', 'vendor/bundle', 'public/system', 'private/files')
set :tmp_dir, "/home/progettilab/shared/tmp"

set :keep_releases, 5

# after 'deploy:finishing',     'deploy:cleanup'
# before 'deploy:log_revision', 'puma:restart'