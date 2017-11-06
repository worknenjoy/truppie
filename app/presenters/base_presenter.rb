class BasePresenter < SimpleDelegator
  include Rails.application.routes.url_helpers

  def object
    __getobj__
  end

  protected
  def h
    ApplicationController.helpers
  end
end
