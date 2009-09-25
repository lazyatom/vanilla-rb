# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{vanilla}
  s.version = "1.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["James Adam"]
  s.date = %q{2009-09-25}
  s.default_executable = %q{vanilla}
  s.email = %q{james@lazyatom.com.com}
  s.executables = ["vanilla"]
  s.extra_rdoc_files = ["README"]
  s.files = ["config.example.yml", "config.ru", "Rakefile", "README", "spec/dynasnip_spec.rb", "spec/renderers", "spec/renderers/base_renderer_spec.rb", "spec/renderers/erb_renderer_spec.rb", "spec/renderers/markdown_renderer_spec.rb", "spec/renderers/raw_renderer_spec.rb", "spec/renderers/ruby_renderer_spec.rb", "spec/renderers/vanilla_app_detecting_renderer_spec.rb", "spec/spec_helper.rb", "spec/tmp", "spec/tmp/config.yml", "spec/tmp/soup", "spec/tmp/soup/current_snip.yml", "spec/tmp/soup/system.yml", "spec/vanilla_app_spec.rb", "spec/vanilla_presenting_spec.rb", "spec/vanilla_request_spec.rb", "lib/defensio.rb", "lib/tasks", "lib/tasks/vanilla.rake", "lib/vanilla", "lib/vanilla/app.rb", "lib/vanilla/console.rb", "lib/vanilla/dynasnip.rb", "lib/vanilla/dynasnips", "lib/vanilla/dynasnips/comments.rb", "lib/vanilla/dynasnips/current_snip.rb", "lib/vanilla/dynasnips/debug.rb", "lib/vanilla/dynasnips/edit.rb", "lib/vanilla/dynasnips/edit_link.rb", "lib/vanilla/dynasnips/index.rb", "lib/vanilla/dynasnips/kind.rb", "lib/vanilla/dynasnips/link_to.rb", "lib/vanilla/dynasnips/link_to_current_snip.rb", "lib/vanilla/dynasnips/login.rb", "lib/vanilla/dynasnips/new.rb", "lib/vanilla/dynasnips/notes.rb", "lib/vanilla/dynasnips/pre.rb", "lib/vanilla/dynasnips/rand.rb", "lib/vanilla/dynasnips/raw.rb", "lib/vanilla/dynasnips/url_to.rb", "lib/vanilla/renderers", "lib/vanilla/renderers/base.rb", "lib/vanilla/renderers/bold.rb", "lib/vanilla/renderers/erb.rb", "lib/vanilla/renderers/markdown.rb", "lib/vanilla/renderers/raw.rb", "lib/vanilla/renderers/ruby.rb", "lib/vanilla/renderers/textile.rb", "lib/vanilla/request.rb", "lib/vanilla/routes.rb", "lib/vanilla/snip_reference.rb", "lib/vanilla/snip_reference.treetop", "lib/vanilla/snip_reference_parser.rb", "lib/vanilla/snips", "lib/vanilla/snips/start.rb", "lib/vanilla/snips/system.rb", "lib/vanilla/snips/tutorial.rb", "lib/vanilla.rb", "bin/vanilla", "public/hatch.png", "public/javascripts", "public/javascripts/jquery.autogrow-textarea.js", "public/javascripts/jquery.js", "public/javascripts/vanilla.js"]
  s.homepage = %q{http://github.com/lazyatom/vanilla-rb}
  s.rdoc_options = ["--main", "README"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{vanilla}
  s.rubygems_version = %q{1.3.3}
  s.summary = %q{A bliki-type web content thing.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rack>, [">= 0.9.1"])
      s.add_runtime_dependency(%q<soup>, [">= 0.2.1"])
      s.add_runtime_dependency(%q<ratom>, [">= 0.3.5"])
      s.add_runtime_dependency(%q<RedCloth>, [">= 4.1.1"])
      s.add_runtime_dependency(%q<BlueCloth>, [">= 1.0.0"])
      s.add_development_dependency(%q<rspec>, [">= 0"])
    else
      s.add_dependency(%q<rack>, [">= 0.9.1"])
      s.add_dependency(%q<soup>, [">= 0.2.1"])
      s.add_dependency(%q<ratom>, [">= 0.3.5"])
      s.add_dependency(%q<RedCloth>, [">= 4.1.1"])
      s.add_dependency(%q<BlueCloth>, [">= 1.0.0"])
      s.add_dependency(%q<rspec>, [">= 0"])
    end
  else
    s.add_dependency(%q<rack>, [">= 0.9.1"])
    s.add_dependency(%q<soup>, [">= 0.2.1"])
    s.add_dependency(%q<ratom>, [">= 0.3.5"])
    s.add_dependency(%q<RedCloth>, [">= 4.1.1"])
    s.add_dependency(%q<BlueCloth>, [">= 1.0.0"])
    s.add_dependency(%q<rspec>, [">= 0"])
  end
end
