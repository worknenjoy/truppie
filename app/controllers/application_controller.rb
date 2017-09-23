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

  def store_current_location
    store_location_for(:user, request.url)
    if request[:organizer] and request[:organizer]["welcome"] == "true"
      session[:organizer_welcome] = true
      session[:organizer_welcome_params] = request[:organizer]
      store_location_for(:user, '/organizers/create_from_auth')
    end
  end

  def check_if_admin
    allowed_emails = [Rails.application.secrets[:admin_email], Rails.application.secrets[:admin_email_alt]]

    if params[:controller] == "organizers" and (params[:action] == "manage" or params[:action] == "tos_acceptance")
      organizer_id = params[:id]
      allowed_emails.push Organizer.find(organizer_id).user.email
    end

    unless allowed_emails.include? current_user.email
      flash[:notice] = "Você não está autorizado a entrar nesta página"
      redirect_to new_user_session_path
    end
  end

  private

  def is_organizer_admin
    if user_signed_in?
      allowed_emails = [Rails.application.secrets[:admin_email], Rails.application.secrets[:admin_email_alt]]

      if params[:controller] == "organizers" and params[:action] == "show"
        organizer_id = params[:id]
        allowed_emails.push Organizer.find(organizer_id).user.email
      end

      unless allowed_emails.include? current_user.email
        return false
      end
      true
    else
      false
    end
  end
end
