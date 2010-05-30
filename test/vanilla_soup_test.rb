require "test_helper"

class VanillaSoupTest < Vanilla::TestCase
  should "convert timestamps to times" do
    snip = create_snip(:name => "temp", :created_at => Time.now.to_s)
    assert_kind_of Time, @app.soup["temp"].created_at
  end
end