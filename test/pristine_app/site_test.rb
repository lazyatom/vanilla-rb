require "test_helper"
require "timeout"

context "Every snip" do
  should "return a 200 response code" do
    snips = app.soup.all_snips
    snips.each do |snip|
      expected_code = 200
      expected_code = 500 if %w(test bad_dynasnip).include?(snip.name)
      begin
        Timeout.timeout(1) do
          get snip.name
          assert_equal expected_code, last_response.status,
                       "#{snip.name} returned a #{last_response.status} response:\n#{last_response.body}"
        end
      rescue Timeout::Error
        flunk "#{snip.name} timed out rendering"
      end
    end
  end

  should "return a 404 for an unknown snip" do
    get 'definitely-not-present-snip'
    assert_equal 404, last_response.status,
                 "should respond with 404 not found for missing snips"
  end
end
