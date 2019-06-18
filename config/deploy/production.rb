role :app, [ "#{Settings.config.application}@"+Rails.application.credentials.deploy[:site_url] ]
role :web, [ "#{Settings.config.application}@"+Rails.application.credentials.deploy[:site_url] ]
role :db,  [ "#{Settings.config.application}b@"+Rails.application.credentials.deploy[:site_url] ]

server Rails.application.credentials.deploy[:site_url], user: "#{Settings.config.application}", roles: %w{app db web}

set :branch, 'master'
set :rails_env, 'production'
set :ssh_options, {:forward_agent => true}