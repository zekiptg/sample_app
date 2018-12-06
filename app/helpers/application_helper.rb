module ApplicationHelper
  # Returns the full title on a per-page basis. # Documentation comment
  def full_title page_title
    return t("title") if page_title.blank?
    page_title + " |" + t("title")
  end
end
