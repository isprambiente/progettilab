# coding: utf-8

%w{
  users analisy_type units nuclides matrices post_seed
}.each do |part|
  require "#{File.expand_path(File.dirname(__FILE__))}/seeds/#{part}.rb"
end

puts "FINITO!!!"