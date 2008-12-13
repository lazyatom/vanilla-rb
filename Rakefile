$LOAD_PATH.unshift File.join(File.dirname(__FILE__), 'lib')
require 'vanilla'

desc "Open an irb session preloaded with this library"
task :console do
  sh "irb -Ilib -rvanilla/console"
end

task :clean do
  # TODO: get the database name from Soup
  FileUtils.rm "soup.db" if File.exist?("soup.db")
end

task :prepare do
  Soup.prepare
end

task :bootstrap => :prepare do  
  Dynasnip.persist_all!(overwrite=true)
  
  Dir[File.join(File.dirname(__FILE__), 'lib', 'vanilla', 'snips', '*.rb')].each do |f|
    p "loading #{f}"
    load f
  end  
  
  load File.join(File.dirname(__FILE__), *%w[lib vanilla test_snips.rb])
  
  puts "The soup is simmering. Loaded #{Soup.tuple_class.count} tuples"
end

desc 'Resets the soup to contain the base snips only. Dangerous!'
task :reset => [:clean, :bootstrap]

namespace :upgrade do
  desc 'Upgrade the dynasnips'
  task :dynasnips => :prepare do
    Dynasnip.all.each do |dynasnip|
      print "Upgrading #{dynasnip.snip_name}... "
      # TODO: our confused Soup interface might return an array.
      snip = Soup[dynasnip.snip_name]
      if snip.empty? || snip.nil?
        # it's a new dyna
        Soup << dynasnip.snip_attributes
        puts "(new)"
      elsif snip.created_at == snip.updated_at
        # it's not been changed, let's upgrade
        snip.destroy
        Soup << dynasnip.snip_attributes
        puts "(unedited)"
      else
        # the dyna exists and has been changed
        dynasnip.snip_attributes.each do |name, value|
          unless (existing_value = snip.get_value(name)) == value
            puts "Conflict in attribute '#{name}':"
            puts "> Your soup: '#{existing_value}'"
            puts ">  New soup: '#{value}"
            print "Upgrade? [Y/n]: "
            upgrade_value = ["Y", "y", ""].include? STDIN.gets.chomp.strip
            snip.set_value(name, value) if upgrade_value
          end
        end
        snip.save
      end
    end
  end
end

desc 'Upgrade dynasnips and system snips'
task :upgrade => ["upgrade:dynasnips"]

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
  secret = OpenSSL::Digest::SHA512.new(data).hexdigest
  app = Vanilla::App.new(ENV['VANILLA_CONFIG'])
  app.config[:secret] = secret
  app.config.save!
  puts "Secret generated."
end


desc 'Prepare a new vanilla.rb installation'
task :setup do
  puts <<-EOM

===================~ Vanilla.rb ~====================

Congratulations! You have elected to try out the weirdest web thing ever.
Lets get started. Firstly, I'm going to cook you some soup:


EOM
  Rake::Task[:bootstrap].invoke
  
  puts <<-EOM
  
Now I'm going to generate your configuration. This will be stored either in
'config.yml' in the current directory, or in the path you provide via the
environment variable VANILLA_CONFIG.  

Generating the secret for cookie-based session storage.
EOM
  Rake::Task[:generate_secret_file].invoke
  
  puts <<-EOM


Now that we've got our broth, you'll want to add a user, so you can edit stuff.
Lets do that now:


EOM
  Rake::Task[:add_user].invoke
  puts <<-EOM


OK! You're ready to go. To start vanilla.rb, you'll want to get it running under
a webserver that supports Rack. The easiest way to do this locally is via 'rackup':
  
  $ rackup
  
Then go to http://localhost:9292

I'm going now, Goodbye!


EOM
end

require 'spec'
require 'spec/rake/spectask'
Spec::Rake::SpecTask.new do |t|
  t.spec_opts = %w(--format specdoc --colour)
  t.libs = ["spec"]
end

task :default => :spec
