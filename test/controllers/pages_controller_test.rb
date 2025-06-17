require "test_helper"

class PagesControllerTest < ActionDispatch::IntegrationTest
  test "should get test_login" do
    get pages_test_login_url
    assert_response :success
  end
end
