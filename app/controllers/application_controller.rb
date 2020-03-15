class ApplicationController < ActionController::Base

  PAGE_DEFAULT = 1
  PER_PAGE_DEFAULT = 10

  private
  def page
    params[:page] || PAGE_DEFAULT
  end

  def per_page
    params[:per_page] || PER_PAGE_DEFAULT
  end
end
