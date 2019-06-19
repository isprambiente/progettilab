namespace :erd do

  desc 'Generate Entity Relationship Diagram'
  task :generate do
    Dir.mkdir 'doc' unless File.directory?('doc')
    File.delete("doc/<%= Settings.config.application %>-model.dot")  if File.exist?("doc/<%= Settings.config.application %>-model.dot")
    File.delete("doc/<%= Settings.config.application %>-controller.dot") if File.exist?("doc/<%= Settings.config.application %>-controller.dot")
    system "railroady -o doc/<%= Settings.config.application %>-model.dot -M"
    system "railroady -o doc/<%= Settings.config.application %>-controller.dot -C"

    system "dot -Tpng <%= Settings.config.application %>-model.dot > <%= Settings.config.application %>-model.svg"
    system "dot -Tpng <%= Settings.config.application %>-controller.dot > <%= Settings.config.application %>-controller.svg"
  end

end