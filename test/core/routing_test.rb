require "test_helper"

context "Parsing routes" do

  { "/" => [nil, nil, nil],
   "/blah" => ["blah", nil, nil],
   "/blah-face" => ["blah-face", nil, nil],
   "/blah+face" => ["blah face", nil, nil],
   "/blah.text" => ["blah", nil, "text"],
   "/blah.html" => ["blah", nil, "html"],
   "/blah/part" => ["blah", "part", nil],
   "/blah/part.raw" => ["blah", "part", "raw"]}.each do |path, (snip, part, format)|

    context "parsing #{path}" do
      setup { @parsed_route = Vanilla::Routing.parse(path) }

      should "return #{snip.inspect} as the snip" do
        assert_equal snip, @parsed_route[0]
      end
      should "return #{part.inspect} as the part" do
        assert_equal part, @parsed_route[1]
      end
      should "return #{format.inspect} as the format" do
        assert_equal format, @parsed_route[2]
      end

    end
  end

end

context "Generating routes" do
  should "generate root path for root snip" do
    assert_equal "/", app.url_to(app.config.root_snip)
  end

  should "include the full snip and part if the root snip part was requested" do
    assert_equal "/start/part", app.url_to(app.config.root_snip, "part")
  end
end
