# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{vanilla}
  s.version = "1.14.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["James Adam"]
  s.date = %q{2011-04-28}
  s.default_executable = %q{vanilla}
  s.email = %q{james@lazyatom.com.com}
  s.executables = ["vanilla"]
  s.extra_rdoc_files = [
    "README"
  ]
  s.files = [
    "Rakefile",
    "README",
    "test/base_renderer_test.rb",
    "test/dynasnip_test.rb",
    "test/erb_renderer_test.rb",
    "test/haml_renderer_test.rb",
    "test/markdown_renderer_test.rb",
    "test/raw_renderer_test.rb",
    "test/ruby_renderer_test.rb",
    "test/snip_reference_parser_test.rb",
    "test/snip_reference_test.rb",
    "test/soup/blah.snip",
    "test/soup/blah.snip.erb",
    "test/soup/blah.snip.haml",
    "test/soup/blah.snip.markdown",
    "test/soup/blah.snip.rb",
    "test/soup/blah.snip.textile",
    "test/soup/current_snip.snip",
    "test/soup/layout.snip",
    "test/soup/test.snip",
    "test/soup/test_dyna.snip",
    "test/test_helper.rb",
    "test/vanilla_app_test.rb",
    "test/vanilla_presenting_test.rb",
    "test/vanilla_request_test.rb",
    "lib/tasks/vanilla.rake",
    "lib/vanilla/app.rb",
    "lib/vanilla/console.rb",
    "lib/vanilla/dynasnip.rb",
    "lib/vanilla/renderers/base.rb",
    "lib/vanilla/renderers/bold.rb",
    "lib/vanilla/renderers/erb.rb",
    "lib/vanilla/renderers/haml.rb",
    "lib/vanilla/renderers/markdown.rb",
    "lib/vanilla/renderers/raw.rb",
    "lib/vanilla/renderers/ruby.rb",
    "lib/vanilla/renderers/textile.rb",
    "lib/vanilla/renderers.rb",
    "lib/vanilla/request.rb",
    "lib/vanilla/routes.rb",
    "lib/vanilla/snip_reference.rb",
    "lib/vanilla/snip_reference.treetop",
    "lib/vanilla/snip_reference_parser.rb",
    "lib/vanilla/static.rb",
    "lib/vanilla.rb",
    "bin/vanilla",
    "pristine_app/config.ru",
    "pristine_app/Gemfile",
    "pristine_app/README",
    "pristine_app/soups/base/layout.snip.erb",
    "pristine_app/soups/base/start.snip",
    "pristine_app/soups/dynasnips/current_snip.rb",
    "pristine_app/soups/dynasnips/debug.rb",
    "pristine_app/soups/dynasnips/index.rb",
    "pristine_app/soups/dynasnips/link_to.rb",
    "pristine_app/soups/dynasnips/link_to_current_snip.rb",
    "pristine_app/soups/dynasnips/page_title.rb",
    "pristine_app/soups/dynasnips/pre.rb",
    "pristine_app/soups/dynasnips/raw.rb",
    "pristine_app/soups/extras/comments.rb",
    "pristine_app/soups/extras/kind.rb",
    "pristine_app/soups/extras/rand.rb",
    "pristine_app/soups/extras/url_to.rb",
    "pristine_app/soups/tutorial/bad_dynasnip.snip",
    "pristine_app/soups/tutorial/hello_world.snip",
    "pristine_app/soups/tutorial/markdown_example.snip",
    "pristine_app/soups/tutorial/snip.snip",
    "pristine_app/soups/tutorial/soup.snip",
    "pristine_app/soups/tutorial/test.snip",
    "pristine_app/soups/tutorial/textile_example.snip",
    "pristine_app/soups/tutorial/tutorial-another-snip.snip",
    "pristine_app/soups/tutorial/tutorial-basic-snip-inclusion.snip",
    "pristine_app/soups/tutorial/vanilla-rb-tutorial.snip",
    "pristine_app/soups/tutorial/vanilla-rb.snip",
    "pristine_app/soups/tutorial/vanilla.snip"
  ]
  s.homepage = %q{http://github.com/lazyatom/vanilla-rb}
  s.rdoc_options = ["--main", "README"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{vanilla}
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{A bliki-type web content thing.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rack>, [">= 0.9.1"])
      s.add_runtime_dependency(%q<soup>, [">= 1.0.6"])
      s.add_runtime_dependency(%q<ratom>, [">= 0.3.5"])
      s.add_runtime_dependency(%q<RedCloth>, [">= 4.1.1"])
      s.add_runtime_dependency(%q<BlueCloth>, [">= 1.0.0"])
      s.add_runtime_dependency(%q<treetop>, [">= 1.4.1"])
      s.add_runtime_dependency(%q<haml>, [">= 0"])
      s.add_development_dependency(%q<kintama>, [">= 0.1.5"])
      s.add_development_dependency(%q<mocha>, [">= 0"])
    else
      s.add_dependency(%q<rack>, [">= 0.9.1"])
      s.add_dependency(%q<soup>, [">= 1.0.6"])
      s.add_dependency(%q<ratom>, [">= 0.3.5"])
      s.add_dependency(%q<RedCloth>, [">= 4.1.1"])
      s.add_dependency(%q<BlueCloth>, [">= 1.0.0"])
      s.add_dependency(%q<treetop>, [">= 1.4.1"])
      s.add_dependency(%q<haml>, [">= 0"])
      s.add_dependency(%q<kintama>, [">= 0.1.5"])
      s.add_dependency(%q<mocha>, [">= 0"])
    end
  else
    s.add_dependency(%q<rack>, [">= 0.9.1"])
    s.add_dependency(%q<soup>, [">= 1.0.6"])
    s.add_dependency(%q<ratom>, [">= 0.3.5"])
    s.add_dependency(%q<RedCloth>, [">= 4.1.1"])
    s.add_dependency(%q<BlueCloth>, [">= 1.0.0"])
    s.add_dependency(%q<treetop>, [">= 1.4.1"])
    s.add_dependency(%q<haml>, [">= 0"])
    s.add_dependency(%q<kintama>, [">= 0.1.5"])
    s.add_dependency(%q<mocha>, [">= 0"])
  end
end
