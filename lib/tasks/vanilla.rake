$LOAD_PATH.unshift(File.expand_path(File.join(File.dirname(__FILE__), '..')))
require 'vanilla'

namespace :vanilla do
  desc "Open an irb session preloaded with this library"
  task :console do
    sh "irb -Ilib -rubygems -rbundler/setup -rvanilla -rvanilla/console"
  end

  desc 'Upgrade dynasnips and system snips'
  task :upgrade do
    # TODO
    puts "TODO, but should be easier thanks to multi-space soup."
  end

  desc 'Prepare a new vanilla.rb installation'
  task :setup do
    
  end
end
