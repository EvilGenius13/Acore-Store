require "test_helper"

class RegistrationServiceTest < ActiveSupport::TestCase
  def setup
    @service = RegistrationService.new
    @valid_user_params = {username: "test", password: "password"}
    @long_password_params = { username: "test", password: "12345678901234567" }
  end

  test "register user returns error when password length exceeds 16 characters" do
    result = @service.register_user(@long_password_params)
    assert_equal :error, result[:status]
    assert_equal "Password cannot exceed 16 characters", result[:error]
  end

  test "register user returns error when username already exists" do
    @service.expects(:username_exists?).returns(true)

    result = @service.register_user(@valid_user_params)

    assert_equal :error, result[:status]
    assert_equal "Username already exists.", result[:error]
  end
end