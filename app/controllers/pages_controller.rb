class PagesController < ApplicationController
  def changelog
    add_breadcrumb "<i class='fa fa-github'> #{I18n.t("breadcrumbs.pages.changelog")}</i>".html_safe
    render template: "pages/changelog"
  end

  def manual
    respond_to do |format|
      format.html do
        add_breadcrumb "<i class='fa fa-book'> #{I18n.t("breadcrumbs.pages.manual")}</i>".html_safe
        render template: "pages/manual"
      end
    end
  end
end