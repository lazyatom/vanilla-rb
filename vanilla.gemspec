# -*- encoding: utf-8 -*-
# stub: vanilla 1.17.13 ruby lib

Gem::Specification.new do |s|
  s.name = "vanilla"
  s.version = "1.17.13"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["James Adam"]
  s.date = "2015-05-09"
  s.email = "james@lazyatom.com.com"
  s.executables = ["vanilla"]
  s.extra_rdoc_files = [
    "README"
  ]
  s.files = [
    ".gemtest",
    "README",
    "Rakefile",
    "bin/vanilla",
    "lib/vanilla.rb",
    "lib/vanilla/app.rb",
    "lib/vanilla/atom_feed.rb",
    "lib/vanilla/config.rb",
    "lib/vanilla/console.rb",
    "lib/vanilla/dynasnip.rb",
    "lib/vanilla/renderers.rb",
    "lib/vanilla/renderers/base.rb",
    "lib/vanilla/renderers/bold.rb",
    "lib/vanilla/renderers/erb.rb",
    "lib/vanilla/renderers/haml.rb",
    "lib/vanilla/renderers/markdown.rb",
    "lib/vanilla/renderers/raw.rb",
    "lib/vanilla/renderers/ruby.rb",
    "lib/vanilla/renderers/textile.rb",
    "lib/vanilla/request.rb",
    "lib/vanilla/routing.rb",
    "lib/vanilla/snip_reference_parser.rb",
    "lib/vanilla/static.rb",
    "lib/vanilla/test_helper.rb",
    "pristine_app/Gemfile",
    "pristine_app/README",
    "pristine_app/application.rb",
    "pristine_app/config.ru",
    "pristine_app/public/vanilla.css",
    "pristine_app/soups/base/feed.rb",
    "pristine_app/soups/base/layout.snip",
    "pristine_app/soups/base/start.snip",
    "pristine_app/soups/extras/comments.rb",
    "pristine_app/soups/extras/kind.rb",
    "pristine_app/soups/extras/rand.rb",
    "pristine_app/soups/extras/url_to.rb",
    "pristine_app/soups/system/current_snip.rb",
    "pristine_app/soups/system/debug.rb",
    "pristine_app/soups/system/index.rb",
    "pristine_app/soups/system/link_to.rb",
    "pristine_app/soups/system/link_to_current_snip.rb",
    "pristine_app/soups/system/page_title.rb",
    "pristine_app/soups/system/pre.rb",
    "pristine_app/soups/system/raw.rb",
    "pristine_app/soups/tutorial/bad_dynasnip.snip",
    "pristine_app/soups/tutorial/hello_world.snip",
    "pristine_app/soups/tutorial/markdown_example.snip",
    "pristine_app/soups/tutorial/snip.snip",
    "pristine_app/soups/tutorial/soup.snip",
    "pristine_app/soups/tutorial/test.snip",
    "pristine_app/soups/tutorial/textile_example.snip",
    "pristine_app/soups/tutorial/tutorial-another-snip.snip",
    "pristine_app/soups/tutorial/tutorial-basic-snip-inclusion.snip",
    "pristine_app/soups/tutorial/tutorial-dynasnips.snip.markdown",
    "pristine_app/soups/tutorial/tutorial-layout.snip",
    "pristine_app/soups/tutorial/tutorial-links.snip",
    "pristine_app/soups/tutorial/tutorial-removing.snip.markdown",
    "pristine_app/soups/tutorial/tutorial-renderers.snip.markdown",
    "pristine_app/soups/tutorial/tutorial.snip.markdown",
    "pristine_app/soups/tutorial/vanilla-rb.snip",
    "pristine_app/soups/tutorial/vanilla.snip",
    "test/core/atom_feed_test.rb",
    "test/core/configuration_test.rb",
    "test/core/dynasnip_test.rb",
    "test/core/renderers/base_renderer_test.rb",
    "test/core/renderers/erb_renderer_test.rb",
    "test/core/renderers/haml_renderer_test.rb",
    "test/core/renderers/markdown_renderer_test.rb",
    "test/core/renderers/raw_renderer_test.rb",
    "test/core/renderers/ruby_renderer_test.rb",
    "test/core/routing_test.rb",
    "test/core/snip_inclusion_test.rb",
    "test/core/snip_reference_parser_test.rb",
    "test/core/test_helper.rb",
    "test/core/vanilla_app_test.rb",
    "test/core/vanilla_presenting_test.rb",
    "test/core/vanilla_request_test.rb",
    "test/pristine_app/current_snip_test.rb",
    "test/pristine_app/feed_test.rb",
    "test/pristine_app/index_test.rb",
    "test/pristine_app/link_to_current_snip_test.rb",
    "test/pristine_app/link_to_test.rb",
    "test/pristine_app/page_title_test.rb",
    "test/pristine_app/raise_errors_test.rb",
    "test/pristine_app/raw_test.rb",
    "test/pristine_app/site_test.rb",
    "test/pristine_app/test_helper.rb"
  ]
  s.homepage = "http://github.com/lazyatom/vanilla-rb"
  s.rdoc_options = ["--main", "README"]
  s.rubyforge_project = "vanilla"
  s.rubygems_version = "2.4.5"
  s.summary = "A bliki-type web content thing."

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rack>, [">= 0.9.1"])
      s.add_runtime_dependency(%q<soup>, [">= 1.0.11"])
      s.add_runtime_dependency(%q<ratom>, [">= 0.3.5"])
      s.add_runtime_dependency(%q<RedCloth>, [">= 4.1.1"])
      s.add_runtime_dependency(%q<BlueCloth>, [">= 1.0.0"])
      s.add_runtime_dependency(%q<haml>, [">= 3.1"])
      s.add_runtime_dependency(%q<parslet>, [">= 1.5.0"])
      s.add_runtime_dependency(%q<rack-test>, [">= 0.5.7"])
      s.add_development_dependency(%q<rake>, [">= 0.9.1"])
      s.add_development_dependency(%q<kintama>, [">= 0.1.11"])
      s.add_development_dependency(%q<mocha>, [">= 0"])
      s.add_development_dependency(%q<capybara>, [">= 0"])
      s.add_development_dependency(%q<launchy>, [">= 0"])
    else
      s.add_dependency(%q<rack>, [">= 0.9.1"])
      s.add_dependency(%q<soup>, [">= 1.0.11"])
      s.add_dependency(%q<ratom>, [">= 0.3.5"])
      s.add_dependency(%q<RedCloth>, [">= 4.1.1"])
      s.add_dependency(%q<BlueCloth>, [">= 1.0.0"])
      s.add_dependency(%q<haml>, [">= 3.1"])
      s.add_dependency(%q<parslet>, [">= 1.5.0"])
      s.add_dependency(%q<rack-test>, [">= 0.5.7"])
      s.add_dependency(%q<rake>, [">= 0.9.1"])
      s.add_dependency(%q<kintama>, [">= 0.1.11"])
      s.add_dependency(%q<mocha>, [">= 0"])
      s.add_dependency(%q<capybara>, [">= 0"])
      s.add_dependency(%q<launchy>, [">= 0"])
    end
  else
    s.add_dependency(%q<rack>, [">= 0.9.1"])
    s.add_dependency(%q<soup>, [">= 1.0.11"])
    s.add_dependency(%q<ratom>, [">= 0.3.5"])
    s.add_dependency(%q<RedCloth>, [">= 4.1.1"])
    s.add_dependency(%q<BlueCloth>, [">= 1.0.0"])
    s.add_dependency(%q<haml>, [">= 3.1"])
    s.add_dependency(%q<parslet>, [">= 1.5.0"])
    s.add_dependency(%q<rack-test>, [">= 0.5.7"])
    s.add_dependency(%q<rake>, [">= 0.9.1"])
    s.add_dependency(%q<kintama>, [">= 0.1.11"])
    s.add_dependency(%q<mocha>, [">= 0"])
    s.add_dependency(%q<capybara>, [">= 0"])
    s.add_dependency(%q<launchy>, [">= 0"])
  end
end
