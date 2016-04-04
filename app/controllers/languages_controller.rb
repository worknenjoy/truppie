class LanguagesController < ApplicationController
  def index
    @languages = Language.all
  end
end
