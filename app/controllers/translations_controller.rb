class TranslationsController < ApplicationController
  def index
    @translations = TRANSLATION_STORE
    
    @translate_yaml_br = config = YAML.load_file('config/locales/pt-BR.yml')
    @translate_yaml_en = config = YAML.load_file('config/locales/en.yml')
    
  end
  
  def create
    I18n.backend.store_translations(params[:locale], {params[:key] => params[:value]}, :escape => false)
    redirect_to translations_url, :notice => "Added translations"
  end
end
