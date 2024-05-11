require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "should get signup page" do
    get signup_url
    assert_response :success
  end

  test "should get login page" do
    get login_url
    assert_response :success
  end
end
