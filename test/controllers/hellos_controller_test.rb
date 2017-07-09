require 'test_helper'

class HellosControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get root_path
    assert_response :success
  end
end
