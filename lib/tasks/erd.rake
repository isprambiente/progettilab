namespace :erd do

  desc 'Generate Entity Relationship Diagram'
  task :generate do
    Dir.mkdir 'doc' unless File.directory?('doc')
    File.delete('doc/progettilab-model.dot')  if File.exist?('doc/progettilab-model.dot')
    File.delete('doc/progettilab-controller.dot') if File.exist?('doc/progettilab-controller.dot')
    system "railroady -o doc/progettilab-model.dot -M"
    system "railroady -o doc/progettilab-controller.dot -C"

    system "dot -Tpng progettilab-model.dot > progettilab-model.svg"
    system "dot -Tpng progettilab-controller.dot > progettilab-controller.svg"
  end

end