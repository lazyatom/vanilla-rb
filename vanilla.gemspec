# -*- encoding: utf-8 -*-
# stub: vanilla 2.0.0.beta ruby lib

Gem::Specification.new do |s|
  s.name = "vanilla".freeze
  s.version = "2.0.0.beta"

  s.required_rubygems_version = Gem::Requirement.new("> 1.3.1".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["James Adam".freeze]
  s.date = "2020-07-10"
  s.email = "james@lazyatom.com.com".freeze
  s.executables = ["vanilla".freeze]
  s.extra_rdoc_files = [
    "README".freeze
  ]
  s.files = [
    ".gemtest".freeze,
    "README".freeze,
    "Rakefile".freeze,
    "bin/vanilla".freeze,
    "lib/vanilla.rb".freeze,
    "lib/vanilla/app.rb".freeze,
    "lib/vanilla/atom_feed.rb".freeze,
    "lib/vanilla/config.rb".freeze,
    "lib/vanilla/console.rb".freeze,
    "lib/vanilla/dynasnip.rb".freeze,
    "lib/vanilla/renderers.rb".freeze,
    "lib/vanilla/renderers/base.rb".freeze,
    "lib/vanilla/renderers/bold.rb".freeze,
    "lib/vanilla/renderers/erb.rb".freeze,
    "lib/vanilla/renderers/haml.rb".freeze,
    "lib/vanilla/renderers/markdown.rb".freeze,
    "lib/vanilla/renderers/raw.rb".freeze,
    "lib/vanilla/renderers/ruby.rb".freeze,
    "lib/vanilla/renderers/textile.rb".freeze,
    "lib/vanilla/request.rb".freeze,
    "lib/vanilla/routing.rb".freeze,
    "lib/vanilla/snip_reference_parser.rb".freeze,
    "lib/vanilla/static.rb".freeze,
    "lib/vanilla/test_helper.rb".freeze,
    "pristine_app/Gemfile".freeze,
    "pristine_app/README".freeze,
    "pristine_app/application.rb".freeze,
    "pristine_app/config.ru".freeze,
    "pristine_app/public/vanilla.css".freeze,
    "pristine_app/soups/base/feed.rb".freeze,
    "pristine_app/soups/base/layout.snip".freeze,
    "pristine_app/soups/base/start.snip".freeze,
    "pristine_app/soups/extras/comments.rb".freeze,
    "pristine_app/soups/extras/kind.rb".freeze,
    "pristine_app/soups/extras/rand.rb".freeze,
    "pristine_app/soups/extras/url_to.rb".freeze,
    "pristine_app/soups/system/current_snip.rb".freeze,
    "pristine_app/soups/system/debug.rb".freeze,
    "pristine_app/soups/system/index.rb".freeze,
    "pristine_app/soups/system/link_to.rb".freeze,
    "pristine_app/soups/system/link_to_current_snip.rb".freeze,
    "pristine_app/soups/system/page_title.rb".freeze,
    "pristine_app/soups/system/pre.rb".freeze,
    "pristine_app/soups/system/raw.rb".freeze,
    "pristine_app/soups/tutorial/bad_dynasnip.snip".freeze,
    "pristine_app/soups/tutorial/hello_world.snip".freeze,
    "pristine_app/soups/tutorial/markdown_example.snip".freeze,
    "pristine_app/soups/tutorial/snip.snip".freeze,
    "pristine_app/soups/tutorial/soup.snip".freeze,
    "pristine_app/soups/tutorial/test.snip".freeze,
    "pristine_app/soups/tutorial/textile_example.snip".freeze,
    "pristine_app/soups/tutorial/tutorial-another-snip.snip".freeze,
    "pristine_app/soups/tutorial/tutorial-basic-snip-inclusion.snip".freeze,
    "pristine_app/soups/tutorial/tutorial-dynasnips.snip.markdown".freeze,
    "pristine_app/soups/tutorial/tutorial-layout.snip".freeze,
    "pristine_app/soups/tutorial/tutorial-links.snip".freeze,
    "pristine_app/soups/tutorial/tutorial-removing.snip.markdown".freeze,
    "pristine_app/soups/tutorial/tutorial-renderers.snip.markdown".freeze,
    "pristine_app/soups/tutorial/tutorial.snip.markdown".freeze,
    "pristine_app/soups/tutorial/vanilla-rb.snip".freeze,
    "pristine_app/soups/tutorial/vanilla.snip".freeze,
    "test/core/atom_feed_test.rb".freeze,
    "test/core/configuration_test.rb".freeze,
    "test/core/dynasnip_test.rb".freeze,
    "test/core/renderers/base_renderer_test.rb".freeze,
    "test/core/renderers/erb_renderer_test.rb".freeze,
    "test/core/renderers/haml_renderer_test.rb".freeze,
    "test/core/renderers/markdown_renderer_test.rb".freeze,
    "test/core/renderers/raw_renderer_test.rb".freeze,
    "test/core/renderers/ruby_renderer_test.rb".freeze,
    "test/core/routing_test.rb".freeze,
    "test/core/snip_inclusion_test.rb".freeze,
    "test/core/snip_reference_parser_test.rb".freeze,
    "test/core/test_helper.rb".freeze,
    "test/core/vanilla_app_test.rb".freeze,
    "test/core/vanilla_presenting_test.rb".freeze,
    "test/core/vanilla_request_test.rb".freeze,
    "test/pristine_app/current_snip_test.rb".freeze,
    "test/pristine_app/feed_test.rb".freeze,
    "test/pristine_app/index_test.rb".freeze,
    "test/pristine_app/link_to_current_snip_test.rb".freeze,
    "test/pristine_app/link_to_test.rb".freeze,
    "test/pristine_app/page_title_test.rb".freeze,
    "test/pristine_app/raise_errors_test.rb".freeze,
    "test/pristine_app/raw_test.rb".freeze,
    "test/pristine_app/site_test.rb".freeze,
    "test/pristine_app/test_helper.rb".freeze
  ]
  s.homepage = "http://github.com/lazyatom/vanilla-rb".freeze
  s.rdoc_options = ["--main".freeze, "README".freeze]
  s.rubygems_version = "3.0.3".freeze
  s.summary = "A bliki-type web content thing.".freeze

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rack>.freeze, [">= 0.9.1"])
      s.add_runtime_dependency(%q<soup>.freeze, [">= 1.0.13"])
      s.add_runtime_dependency(%q<ratom>.freeze, [">= 0.3.5"])
      s.add_runtime_dependency(%q<RedCloth>.freeze, [">= 4.1.1"])
      s.add_runtime_dependency(%q<bluecloth>.freeze, [">= 2.0.0"])
      s.add_runtime_dependency(%q<haml>.freeze, [">= 3.1"])
      s.add_runtime_dependency(%q<parslet>.freeze, [">= 1.5.0"])
      s.add_runtime_dependency(%q<rack-test>.freeze, [">= 0.5.7"])
      s.add_development_dependency(%q<rake>.freeze, [">= 0.9.1"])
      s.add_development_dependency(%q<kintama>.freeze, [">= 0.2"])
      s.add_development_dependency(%q<mocha>.freeze, [">= 0"])
      s.add_development_dependency(%q<capybara>.freeze, [">= 0"])
      s.add_development_dependency(%q<launchy>.freeze, [">= 0"])
    else
      s.add_dependency(%q<rack>.freeze, [">= 0.9.1"])
      s.add_dependency(%q<soup>.freeze, [">= 1.0.13"])
      s.add_dependency(%q<ratom>.freeze, [">= 0.3.5"])
      s.add_dependency(%q<RedCloth>.freeze, [">= 4.1.1"])
      s.add_dependency(%q<bluecloth>.freeze, [">= 2.0.0"])
      s.add_dependency(%q<haml>.freeze, [">= 3.1"])
      s.add_dependency(%q<parslet>.freeze, [">= 1.5.0"])
      s.add_dependency(%q<rack-test>.freeze, [">= 0.5.7"])
      s.add_dependency(%q<rake>.freeze, [">= 0.9.1"])
      s.add_dependency(%q<kintama>.freeze, [">= 0.2"])
      s.add_dependency(%q<mocha>.freeze, [">= 0"])
      s.add_dependency(%q<capybara>.freeze, [">= 0"])
      s.add_dependency(%q<launchy>.freeze, [">= 0"])
    end
  else
    s.add_dependency(%q<rack>.freeze, [">= 0.9.1"])
    s.add_dependency(%q<soup>.freeze, [">= 1.0.13"])
    s.add_dependency(%q<ratom>.freeze, [">= 0.3.5"])
    s.add_dependency(%q<RedCloth>.freeze, [">= 4.1.1"])
    s.add_dependency(%q<bluecloth>.freeze, [">= 2.0.0"])
    s.add_dependency(%q<haml>.freeze, [">= 3.1"])
    s.add_dependency(%q<parslet>.freeze, [">= 1.5.0"])
    s.add_dependency(%q<rack-test>.freeze, [">= 0.5.7"])
    s.add_dependency(%q<rake>.freeze, [">= 0.9.1"])
    s.add_dependency(%q<kintama>.freeze, [">= 0.2"])
    s.add_dependency(%q<mocha>.freeze, [">= 0"])
    s.add_dependency(%q<capybara>.freeze, [">= 0"])
    s.add_dependency(%q<launchy>.freeze, [">= 0"])
  end
end
