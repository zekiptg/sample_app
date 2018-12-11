require "test_helper"

class UsersSignupTest < ActionDispatch::IntegrationTest
  def setup
    ActionMailer::Base.deliveries.clear
  end

  test "invalid signup information" do
    get signup_path
    assert_no_difference "User.count" do
      testdata = {
        name: "",
        email: "user@invalid",
        password: "foo",
        password_confirmation: "bar"
      }
      post users_path, params: {user: testdata}
    end
    assert_template "users/new"
    assert_select "div[id=?]", "error_explanation"
    assert_select "div[class=?]", "alert alert-danger"
  end

  test "valid singup information" do
    get signup_path
    assert_difference "User.count" do
      testdata = {
        name: "huynguyen",
        email: "huynguyenas@gmail.com",
        password: "foo12345",
        password_confirmation: "foo12345"
      }
      post users_path, params: {user: testdata}
    end
    follow_redirect!
  end

  test "valid signup information with account activation" do
    @data = {
      name: "Example User", email: "user@example.com",
      password: "password", password_confirmation: "password"
    }
    get signup_path
    assert_difference "User.count", 1 do
      post users_path, params: {user: @data}
    end
    assert_equal 1, ActionMailer::Base.deliveries.size
    user = assigns(:user)
    assert_not user.activated?
    log_in_as(user)
    assert_not is_logged_in?
    get edit_account_activation_path("invalid token", email: user.email)
    assert_not is_logged_in?
    get edit_account_activation_path(user.activation_token, email: "wrong")
    assert_not is_logged_in?
    get edit_account_activation_path(user.activation_token, email: user.email)
    assert user.reload.activated?
    follow_redirect!
    assert_template "users/show"
    assert is_logged_in?
  end
end
