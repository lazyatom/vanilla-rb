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

  desc 'Add a user (or change an existing password)'
  task :add_user => :prepare do
    puts "Adding a new user"
    # config_file = ENV['VANILLA_CONFIG'] || 'config.yml'
    # config_file = YAML.load(File.open(config_file)) rescue {}
    app = Vanilla::App.new(ENV['VANILLA_CONFIG'])
    print "Username: "
    username = STDIN.gets.chomp.strip
    print "Password: "
    password = STDIN.gets.chomp.strip
    print "Confirm password: "
    confirm_password = STDIN.gets.chomp.strip
    if password != confirm_password
      raise "Passwords don't match!"
    else
      app.config[:credentials] ||= {}
      app.config[:credentials][username] = MD5.md5(password).to_s
      app.config.save!
      puts "User '#{username}' added."
    end
  end

  desc 'Generate file containing secret for cookie-based session storage'
  task :generate_secret do
    print "Generating cookie secret... "
    # Adapted from old rails secret generator.
    require 'openssl'
    if !File.exist?("/dev/urandom")
      # OpenSSL transparently seeds the random number generator with
      # data from /dev/urandom. On platforms where that is not
      # available, such as Windows, we have to provide OpenSSL with
      # our own seed. Unfortunately there's no way to provide a
      # secure seed without OS support, so we'll have to do with
      # rand() and Time.now.usec().
      OpenSSL::Random.seed(rand(0).to_s + Time.now.usec.to_s)
    end
    data = OpenSSL::BN.rand(2048, -1, false).to_s
    secret = OpenSSL::Digest::SHA1.new(data).hexdigest
    app = Vanilla::App.new(ENV['VANILLA_CONFIG'])
    app.config[:secret] = secret
    app.config.save!
    puts "done; cookies are twice baked. BIS-CUIT!"
  end

  desc 'Prepare a new vanilla.rb installation'
  task :setup do
    puts <<-EOM
____________________.c( Vanilla.rb )o._____________________

Congratulations! You have elected to try out the weirdest web
thing ever. Lets get started.

EOM
  Rake::Task['vanilla:setup:prepare_files'].invoke
  Rake::Task['vanilla:generate_secret'].invoke
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
    end

    task :load_snips do
      print "Preparing soup... "
      system_soup = ::Soup.new(::Soup::Backends::YAMLBackend.new("soup/system"))
      system_soup << eval(File.read(File.join(File.dirname(__FILE__), '..', 'vanilla', 'snips', 'system.rb')))
      dynasnip_soup = ::Soup.new(::Soup::Backends::YAMLBackend.new("soup/system/dynasnips"))
      Dynasnip.all.each { |ds| dynasnip_soup << ds.snip_attributes }
      Dir[File.join(File.dirname(__FILE__), '..', 'vanilla', 'snips', '{start,tutorial}.rb')].each do |f|
        load f
      end
      puts "the soup is simmering."
    end
  end
end
