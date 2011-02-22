$LOAD_PATH.unshift(File.expand_path(File.join(File.dirname(__FILE__), '..')))
require 'vanilla'

namespace :vanilla do
  desc "Open an irb session preloaded with this library"
  task :console do
    sh "irb -Ilib -rubygems -rvanilla -rvanilla/console"
  end

  desc 'Upgrade dynasnips and system snips'
  task :upgrade do
    # TODO
    puts "TODO, but should be easier thanks to multi-space soup."
  end

  desc 'Prepare a new vanilla.rb installation'
  task :setup do
    puts <<-EOM
____________________.c( Vanilla.rb )o._____________________

Congratulations! You have elected to try out the weirdest web
thing ever. Lets get started.

EOM
  Rake::Task['vanilla:setup:prepare_files'].invoke
  Rake::Task['vanilla:setup:load_snips'].invoke

  puts <<-EOM

___________________.c( You Are Ready )o.___________________

#{File.readlines('README')[0,16].join}
  EOM
  end

  namespace :setup do
    desc 'Prepare standard files to run Vanilla'
    task :prepare_files do
      cp File.expand_path(File.join(File.dirname(__FILE__), *%w[.. .. config.ru])), 'config.ru'
      cp File.expand_path(File.join(File.dirname(__FILE__), *%w[.. .. config.example.yml])), 'config.yml'
      cp File.expand_path(File.join(File.dirname(__FILE__), *%w[.. .. README_FOR_APP])), 'README'
      cp_r File.expand_path(File.join(File.dirname(__FILE__), *%w[.. .. public])), 'public'
      mkdir 'tmp'
      File.open("Rakefile", "w") do |f|
        rakefile =<<-EOF
require 'vanilla'
load 'tasks/vanilla.rake'

# Add any other tasks here.
EOF
        f.write rakefile.strip
      end
      File.open("Gemfile", "w") do |f|
        gemfile =<<-EOF
source :rubygems

gem "vanilla", #{Vanilla::VERSION.inspect}
EOF
        f.write gemfile.strip
      end
    end

    task :load_snips do
      print "Preparing soup... "

      mkdir_p "soup/system"
      FileUtils.cp_r(File.join(File.dirname(__FILE__), '..', 'vanilla', 'snips', 'system'), "soup")
      FileUtils.cp_r(File.join(File.dirname(__FILE__), '..', 'vanilla', 'snips', 'tutorial'), "soup")

      dynasnip_soup = ::Soup.new(::Soup::Backends::FileBackend.new("soup/system/dynasnips"))
      Dynasnip.all.each { |ds| dynasnip_soup << ds.snip_attributes }
      puts "the soup is simmering."
    end
  end
end
