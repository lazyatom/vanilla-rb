require "rubygems"
require "rubygems/package_task"
require "rdoc/task"

require "bundler/setup"
require "vanilla"

task :default => :test

task :test => ["test:core", "test:app"]

namespace :test do
  require "rake/testtask"
  Rake::TestTask.new(:core) do |t|
    t.libs << "test/core"
    t.ruby_opts << "-rubygems"
    t.test_files = FileList["test/core/**/*_test.rb"]
    t.verbose = true
  end

  Rake::TestTask.new(:app) do |t|
    t.libs << "test/pristine_app"
    t.ruby_opts << "-rubygems"
    t.test_files = FileList["test/pristine_app/**/*_test.rb"]
    t.verbose = true
  end
end

if Object.const_defined?(:Gem)

  def files_for_inclusion
    base_files = %w(Rakefile README .gemtest) + Dir.glob("{test,lib,bin,pristine_app}/**/*").select { |f| File.file?(f) }
    files_to_ignore = File.readlines(".gitignore").inject([]) do |a,p|
      path = p.strip
      a += Dir.glob(path)
      if File.directory?(path)
        a += Dir.glob(path + "/*")
      end
      a
    end
    base_files - files_to_ignore
  end

  # This builds the actual gem. For details of what all these options
  # mean, and other ones you can add, check the documentation here:
  #
  #   http://rubygems.org/read/chapter/20
  #
  spec = Gem::Specification.new do |s|

    # Change these as appropriate
    s.name              = "vanilla"
    s.version           = Vanilla::VERSION
    s.summary           = "A bliki-type web content thing."
    s.author            = "James Adam"
    s.email             = "james@lazyatom.com.com"
    s.homepage          = "http://github.com/lazyatom/vanilla-rb"

    s.has_rdoc          = true
    s.extra_rdoc_files  = %w(README)
    s.rdoc_options      = %w(--main README)

    # Add any extra files to include in the gem
    s.files             = files_for_inclusion
    s.executables       = ['vanilla']
    s.require_paths     = ["lib"]

    # All the other gems we need.
    s.add_dependency("rack", ">= 0.9.1")
    s.add_dependency("soup", ">= 1.0.11")
    s.add_dependency("ratom", ">= 0.3.5")
    s.add_dependency("RedCloth", ">= 4.1.1")
    s.add_dependency("BlueCloth", ">= 1.0.0")
    s.add_dependency("haml", ">=3.1")
    s.add_dependency("parslet", "~> 1.5.0")
    s.add_dependency("rack-test", ">=0.5.7")

    s.add_development_dependency("rake", ">= 0.9.1")
    s.add_development_dependency("kintama", ">= 0.1.11") # add any other gems for testing/development
    s.add_development_dependency("mocha")
    s.add_development_dependency("capybara")
    s.add_development_dependency("launchy")

    # If you want to publish automatically to rubyforge, you'll may need
    # to tweak this, and the publishing task below too.
    s.rubyforge_project = "vanilla"
  end

  # This task actually builds the gem. We also regenerate a static
  # .gemspec file, which is useful if something (i.e. GitHub) will
  # be automatically building a gem for this project. If you're not
  # using GitHub, edit as appropriate.
  #
  # To publish your gem online, install the 'gemcutter' gem; Read more
  # about that here: http://gemcutter.org/pages/gem_docs
  Gem::PackageTask.new(spec) do |pkg|
    pkg.gem_spec = spec
  end

  # Stolen from jeweler
  def prettyify_array(gemspec_ruby, array_name)
    gemspec_ruby.gsub(/s\.#{array_name.to_s} = \[.+?\]/) do |match|
      leadin, files = match[0..-2].split("[")
      leadin + "[\n    #{files.split(",").join(",\n   ")}\n  ]"
    end
  end

  task :gemspec do
    output = spec.to_ruby
    output = prettyify_array(output, :files)
    output = prettyify_array(output, :test_files)
    output = prettyify_array(output, :extra_rdoc_files)

    file = File.expand_path("../#{spec.name}.gemspec", __FILE__)
    File.open(file, "w") {|f| f << output }
  end

  task :package => :gemspec

  # Generate documentation
  Rake::RDocTask.new do |rd|
    rd.main = "README"
    rd.rdoc_files.include("README", "lib/**/*.rb")
    rd.rdoc_dir = "rdoc"
  end

  desc 'Clear out RDoc and generated packages'
  task :clean => [:clobber_rdoc, :clobber_package]

  desc 'Tag the repository in git with gem version number'
  task :tag => [:gemspec, :package] do
    if `git diff --cached`.empty?
      if `git tag`.split("\n").include?("v#{spec.version}")
        raise "Version #{spec.version} has already been released"
      end
      `git add #{File.expand_path("../#{spec.name}.gemspec", __FILE__)}`
      `git commit -m "Released version #{spec.version}"`
      `git tag v#{spec.version}`
      `git push --tags`
      `git push`
    else
      raise "Unstaged changes still waiting to be committed"
    end
  end

  desc "Tag and publish the gem to rubygems.org"
  task :publish => :tag do
    `gem push pkg/#{spec.name}-#{spec.version}.gem`
  end
else
  puts "Gem management tasks unavailable, as rubygems was not fully loaded."
end
