require "test_helper"

class PasswordResetsTest < ActionDispatch::IntegrationTest
  def setup
    ActionMailer::Base.deliveries.clear
    @user = users(:michael)
  end

  test "Invalid, valid email" do
    get new_password_reset_path
    assert_template "en/password_resets/new"
    post password_resets_path, params: {password_reset: {email: ""}},
      locale: :en
    assert_not flash.empty?
    assert_template "en/password_resets/new"
    post password_resets_path,
      params: {password_reset: {email: @user.email}}, locale: :en
    assert_not_equal @user.reset_digest, @user.reload.reset_digest
    assert_equal 1, ActionMailer::Base.deliveries.size
    assert_not flash.empty?
    assert_redirected_to root_url
  end

  test "Password reset form" do
    # Password reset form
    user = assigns :user
    get edit_password_reset_path user.reset_token, email: ""
    assert_redirected_to root_url

    # Inactive user
    user.toggle! :activated
    get edit_password_reset_path user.reset_token, email: user.email
    assert_redirected_to root_url
    user.toggle! :activated

    # Right email, wrong token
    get edit_password_reset_path("wrong token", email: user.email)
    assert_redirected_to root_url

    # Right email, right token
    get edit_password_reset_path user.reset_token, email: user.email
    assert_template "en/password_resets/edit"
    assert_select "input[name=email][type=hidden][value=?]", user.email

    # Invalid password & confirmation
    patch password_reset_path(user.reset_token), params: {
      mail: user.email, user: {
        password: "foobaz",
        password_confirmation: "barquux"
      }
    }, locale: :en
    assert_select "div#error_explanation"

    # Empty password
    patch password_reset_path(user.reset_token), params: {
      email: user.email, user: {password: "", password_confirmation: ""}
    }, locale: :en
    assert_select "div#error_explanation"
  end

  test "Valid password & confirmation" do
    patch password_reset_path(@user.reset_token), params: {
      email: @user.email, user: {
        password: "foobaz", password_confirmation: "foobaz"
      }
    }, locale: :en
    assert is_logged_in?
    assert_not flash.empty?
    assert_redirected_to @user
  end

  test "expired token" do
    get new_password_reset_path
    post password_resets_path, params: {
      password_reset: {email: @user.email, locale: :end}
    }
    @user = assigns :user
    @user.update_attribute :reset_sent_at, 3.hours.ago
    patch password_reset_path(@user.reset_token), params: {
      email: @user.email, user: {
        password: "foobar", password_confirmation: "foobar"
      }
    }
    assert_response :redirect
    follow_redirect!
    assert_match t("label.form.passforgot.email"), response.body
  end
end
