namespace :logs do
  desc 'Historicize logs'
  task historicized: :environment do
    Log.historicize
  end

end