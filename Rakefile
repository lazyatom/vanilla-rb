require "rubygems"
require "rake/gempackagetask"
require "rake/rdoctask"

require "bundler/setup"
require "vanilla"

task :default => :test

require "rake/testtask"
Rake::TestTask.new do |t|
  t.libs << "test"
  t.ruby_opts << "-rubygems"
  t.test_files = FileList["test/**/*_test.rb"]
  t.verbose = true
end

if Object.const_defined?(:Gem)
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
    s.files             = %w(Rakefile README .gemtest) + Dir.glob("{lib,bin,pristine_app}/**/*")
    s.executables       = ['vanilla']
    s.require_paths     = ["lib"]
    s.test_files        = Dir.glob("test/**/*")

    # All the other gems we need.
    s.add_dependency("rack", ">= 0.9.1")
    s.add_dependency("soup", ">= 1.0.6")
    s.add_dependency("ratom", ">= 0.3.5")
    s.add_dependency("RedCloth", ">= 4.1.1")
    s.add_dependency("BlueCloth", ">= 1.0.0")
    s.add_dependency("haml")
    s.add_dependency("parslet", ">= 1.2.0")

    s.add_development_dependency("kintama", ">= 0.1.6") # add any other gems for testing/development
    s.add_development_dependency("mocha")

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
  Rake::GemPackageTask.new(spec) do |pkg|
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
  task :clean => [:clobber_rdoc, :clobber_package] do
    rm "#{spec.name}.gemspec"
  end

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