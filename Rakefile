$LOAD_PATH.unshift File.join(File.dirname(__FILE__), 'lib')
require 'vanilla'

desc "Open an irb session preloaded with this library"
task :console do
  sh "irb -Ilib -rvanilla"
end

task :clean do
  # TODO: get the database name from Soup
  FileUtils.rm "soup.db" if File.exist?("soup.db")
end

task :bootstrap do
  Soup.prepare 
  
  require 'vanilla/snip_helper'

  Dynasnip.persist_all!
  
  Dir[File.join(File.dirname(__FILE__), 'lib', 'vanilla', 'snips', '*.rb')].each do |f|
    load f
  end  
  
  load File.join(File.dirname(__FILE__), *%w[vanilla test_snips.rb])
  
  puts "The soup is simmering. Loaded #{Soup.tuple_class.count} tuples"
end

require 'spec'
require 'spec/rake/spectask'
Spec::Rake::SpecTask.new do |t|
  t.spec_opts = %w(--format specdoc --colour)
  t.libs = ["spec"]
end

task :default => :spec