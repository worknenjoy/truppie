class WelcomeController < ApplicationController
  
  def index
    I18n.locale = 'pt-BR'
  end
  
end
