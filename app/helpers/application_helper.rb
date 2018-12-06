module ApplicationHelper
  # Returns the full title on a per-page basis. # Documentation comment
  def full_title page_title
    return I18n.t("keywords.general.title") if page_title.blank?
    page_title + " | " + I18n.t("keywords.general.title")
  end
end
