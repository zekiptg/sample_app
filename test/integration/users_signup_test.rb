require "test_helper"

class UsersSignupTest < ActionDispatch::IntegrationTest
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
    assert_template "users/show"
    assert_not flash[:success].empty?
  end
end
