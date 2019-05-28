role :app, [ 'progettilab@'+Rails.application.credentials.deploy[:site_url] ]
role :web, [ 'progettilab@'+Rails.application.credentials.deploy[:site_url] ]
role :db,  [ 'progettilab@'+Rails.application.credentials.deploy[:site_url] ]

server Rails.application.credentials.deploy[:site_url], user: 'progettilab', roles: %w{app db web}

set :branch, 'master'
set :rails_env, 'production'
set :ssh_options, {:forward_agent => true}