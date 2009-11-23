$LOAD_PATH.unshift File.join(File.dirname(__FILE__), 'lib')
require 'vanilla'
load File.join(File.dirname(__FILE__), *%w[lib tasks vanilla.rake])

task :default => :test

require "rake/testtask"
Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList["test/**/*_test.rb"]
  t.verbose = true
end

require "rubygems"
require "rake/gempackagetask"
require "rake/rdoctask"

if Object.const_defined?(:Gem)
  # This builds the actual gem. For details of what all these options
  # mean, and other ones you can add, check the documentation here:
  #
  #   http://rubygems.org/read/chapter/20
  #
  spec = Gem::Specification.new do |s|

    # Change these as appropriate
    s.name              = "vanilla"
    s.version           = "1.9.13.3"
    s.summary           = "A bliki-type web content thing."
    s.author            = "James Adam"
    s.email             = "james@lazyatom.com.com"
    s.homepage          = "http://github.com/lazyatom/vanilla-rb"

    s.has_rdoc          = true
    s.extra_rdoc_files  = %w(README)
    s.rdoc_options      = %w(--main README)

    # Add any extra files to include in the gem
    s.files             = %w(config.example.yml config.ru Rakefile README README_FOR_APP) + Dir.glob("{test,lib,bin,public}/**/*")
    s.executables       = ['vanilla']
    s.require_paths     = ["lib"]

    # All the other gems we need.
    s.add_dependency("rack", ">= 0.9.1")
    s.add_dependency("soup", ">= 0.9.9")
    s.add_dependency("ratom", ">= 0.3.5")
    s.add_dependency("RedCloth", ">= 4.1.1")
    s.add_dependency("BlueCloth", ">= 1.0.0")
    s.add_dependency("treetop", ">= 1.4.1")
    s.add_dependency("warden", ">= 0.5.2")

    s.add_development_dependency("shoulda") # add any other gems for testing/development
    s.add_development_dependency("mocha")

    # If you want to publish automatically to rubyforge, you'll may need
    # to tweak this, and the publishing task below too.
    s.rubyforge_project = "vanilla"
  end

  # This task actually builds the gem. We also regenerate a static 
  # .gemspec file, which is useful if something (i.e. GitHub) will
  # be automatically building a gem for this project. If you're not
  # using GitHub, edit as appropriate.
  Rake::GemPackageTask.new(spec) do |pkg|
    pkg.gem_spec = spec

    # Generate the gemspec file for github.
    file = File.dirname(__FILE__) + "/#{spec.name}.gemspec"
    File.open(file, "w") {|f| f << spec.to_ruby }
  end

  # Generate documentation
  Rake::RDocTask.new do |rd|
    rd.main = "README"
    rd.rdoc_files.include("README", "lib/**/*.rb")
    rd.rdoc_dir = "rdoc"
  end

  desc 'Clear out RDoc and generated packages'
  task :clean => [:clobber_rdoc, :clobber_package] do
    rm "#{spec.name}.gemspec"
  end

  # If you want to publish to RubyForge automatically, here's a simple 
  # task to help do that. If you don't, just get rid of this.
  # Be sure to set up your Rubyforge account details with the Rubyforge
  # gem; you'll need to run `rubyforge setup` and `rubyforge config` at
  # the very least.
  begin
    require "rake/contrib/sshpublisher"
    namespace :rubyforge do
  
      desc "Release gem and RDoc documentation to RubyForge"
      task :release => ["rubyforge:release:gem", "rubyforge:release:docs"]
  
      namespace :release do
        desc "Release a new version of this gem"
        task :gem => [:package] do
          require 'rubyforge'
          rubyforge = RubyForge.new
          rubyforge.configure
          rubyforge.login
          rubyforge.userconfig['release_notes'] = spec.summary
          path_to_gem = File.join(File.dirname(__FILE__), "pkg", "#{spec.name}-#{spec.version}.gem")
          puts "Publishing #{spec.name}-#{spec.version.to_s} to Rubyforge..."
          rubyforge.add_release(spec.rubyforge_project, spec.name, spec.version.to_s, path_to_gem)
        end
  
        desc "Publish RDoc to RubyForge."
        task :docs => [:rdoc] do
          config = YAML.load(
              File.read(File.expand_path('~/.rubyforge/user-config.yml'))
          )

          host = "#{config['username']}@rubyforge.org"
          remote_dir = "/var/www/gforge-projects/vanilla-rb/" # Should be the same as the rubyforge project name
          local_dir = 'rdoc'

          Rake::SshDirPublisher.new(host, remote_dir, local_dir).upload
        end
      end
    end
  rescue LoadError
    puts "Rake SshDirPublisher is unavailable or your rubyforge environment is not configured."
  end
else
  puts "Gem management tasks unavailable, as rubygems was not fully loaded."
end