class WelcomeController < ApplicationController
  include ApplicationHelper
  
  def index
    @tours = Tour.publisheds.nexts
    @organizers = Organizer.publisheds.order(created_at: :asc)
  end
  
  def organizer
     @organizer = Organizer.where(:user => current_user)
     @new_organizer = Organizer.new
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
