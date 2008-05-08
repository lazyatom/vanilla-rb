$LOAD_PATH.unshift File.join(File.dirname(__FILE__), 'lib')
require 'vanilla'

Soup.prepare 

desc "Open an irb session preloaded with this library"
task :console do
  sh "irb -Ilib -rvanilla"
end

task :clean do
  # TODO: get the database name from Soup
  FileUtils.rm "soup.db" if File.exist?("soup.db")
end

task :bootstrap do
  require 'vanilla/snip_helper'

  Dynasnip.persist_all!(overwrite=true)
  
  Dir[File.join(File.dirname(__FILE__), 'lib', 'vanilla', 'snips', '*.rb')].each do |f|
    load f
  end  
  
  load File.join(File.dirname(__FILE__), *%w[lib vanilla test_snips.rb])
  
  puts "The soup is simmering. Loaded #{Soup.tuple_class.count} tuples"
end

desc 'Resets the soup to contain the base snips only. Dangerous!'
task :reset => [:clean, :bootstrap]

namespace :upgrade do
  desc 'Upgrade the dynasnips'
  task :dynasnips do
    Dynasnip.persist_all!
  end
end

desc 'Upgrade dynasnips and system snips'
task :upgrade => ["upgrade:dynasnips"]

require 'spec'
require 'spec/rake/spectask'
Spec::Rake::SpecTask.new do |t|
  t.spec_opts = %w(--format specdoc --colour)
  t.libs = ["spec"]
end

task :default => :spec