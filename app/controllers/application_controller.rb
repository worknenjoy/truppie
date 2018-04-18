class ApplicationController < ActionController::Base
  #force_ssl if: :ssl_configured?
  helper_method :is_organizer_admin

  #def ssl_configured?
  #  !Rails.env.development?
  #end  
  
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  include ApplicationHelper

  before_filter :store_current_location, :unless => :devise_controller?
  before_filter :set_locale

  def store_current_location
    unless request.format == :js
      store_location_for(:user, request.url)
      if request[:organizer] and request[:organizer]["welcome"] == "true" and !current_user
        session[:organizer_welcome] = true
        session[:organizer_welcome_params] = request[:organizer]
        store_location_for(:user, '/organizers/create_from_auth')
      end
    end
  end

  def check_if_super_admin
    allowed_emails = [Rails.application.secrets[:admin_email], Rails.application.secrets[:admin_email_alt]]
    unless allowed_emails.include? current_user.email
      flash[:notice] = t('tours_controller_notice_one')
      redirect_to root_url
    end
  end

  def check_if_organizer_admin
    allowed_emails = [Rails.application.secrets[:admin_email], Rails.application.secrets[:admin_email_alt]]
    allowed_users = []

    if params[:controller] == "organizers" and params[:id]
      organizer_id = params[:id]
      if organizer_id
        allowed_users.push Organizer.find(organizer_id).user
      end
    end

    if params[:controller] == "tours"
      if params[:tour]
        organizer_id = params[:tour][:organizer_id]
        if organizer_id
          allowed_users.push Organizer.find(organizer_id).user
        end
      else
        tour_id = params[:id]
        if tour_id
          allowed_users.push Tour.find(tour_id).user
        end
      end
    end

    unless allowed_emails.include? current_user.email or allowed_users.include? current_user
      flash[:notice] = "Você não está autorizado a entrar nesta página"
      redirect_to new_user_session_path
    end
  end

  private
  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options(options = {})
    { :locale => ((I18n.locale == I18n.default_locale) ? nil : I18n.locale) }
  end

  def is_organizer_admin
    if user_signed_in?
      allowed_emails = [Rails.application.secrets[:admin_email], Rails.application.secrets[:admin_email_alt]]

      allowed_users = []

      if params[:controller] == "organizers"
        organizer_id = params[:id]
        if organizer_id
          allowed_users.push Organizer.find(organizer_id).user
        end
      end

      if params[:controller] == "tours"
        if params[:tour]
          organizer_id = params[:tour][:organizer_id]
          if organizer_id
            allowed_users.push Organizer.find(organizer_id).user
          end
        else
          tour_id = params[:id]
          if tour_id
            allowed_users.push Tour.find(tour_id).user
          end
        end
      end

      unless allowed_emails.include? current_user.email or allowed_users.include? current_user
        return false
      end
      true
    else
      false
    end
  end
end
