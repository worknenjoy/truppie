class TranslationsController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @translations = TRANSLATION_STORE
    
    @translate_yaml_br = YAML.load_file('config/locales/pt-BR.yml')
    @translate_yaml_en = YAML.load_file('config/locales/en.yml')
    
  end
  
  def create
    I18n.backend.store_translations(params[:locale], {params[:key] => params[:value]}, :escape => false)
    redirect_to translations_url, :success => "Added translations"
  end
end
