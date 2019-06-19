role :app, [ "progettilab@progettirad.areafisica.cnlab.intranet.isprambiente.it" ]
role :web, [ "progettilab@progettirad.areafisica.cnlab.intranet.isprambiente.it" ]
role :db,  [ "progettilab@progettirad.areafisica.cnlab.intranet.isprambiente.it" ]

server "progettirad.areafisica.cnlab.intranet.isprambiente.it", user: "progettilab", roles: %w{app db web}

set :branch, 'master'
set :rails_env, 'production'
set :ssh_options, {:forward_agent => true}