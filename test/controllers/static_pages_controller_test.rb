require "test_helper"

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  test "should get home" do
    get root_path
    assert_response :success
    assert_select "title", I18n.t("keywords.general.title")
  end

  test "should get help" do
    get helf_path
    assert_response :success
    assert_select "title", "Help | " + I18n.t("keywords.general.title")
  end

  test "should get about" do
    get about_path
    assert_response :success
    assert_select "title", "About | " + I18n.t("keywords.general.title")
  end

  test "should get contact" do
    get contact_path
    assert_response :success
    assert_select "title", "Contact | " + I18n.t("keywords.general.title")
  end
end
