class WelcomeController < ApplicationController
  include ApplicationHelper

  def change_locale
    l = params[:locale].to_s.strip.to_sym
    l = I18n.default_locale unless I18n.available_locales.include?(l)
    cookies.permanent[:my_locale] = l
    redirect_to request.referer || root_url
  end
  
  def index
    @tours = Tour.publisheds
    @next_tour = Tour.recents.first
    @next_tours = Tour.publisheds.nexts
    @past_tours = Tour.publisheds.past
    @organizers = Organizer.publisheds.order(created_at: :asc)
    @guidebooks = Guidebook.publisheds
  end
  
  def organizer
    @organizer = Organizer.find_by(user_id: current_user.id)
    if @organizer
      redirect_to profile_edit_organizer_path(@organizer)
    else
      @new_organizer = Organizer.new
    end
  end

  def user
    @backgrounds = Background.all
  end
  
  def logos
    
  end
  
  def manifest
    
  end
  
  def how_it_works
    
  end
  
  def privacy
    
  end
  
  def defs
    
  end
  
  def faq
    
  end
  
end
