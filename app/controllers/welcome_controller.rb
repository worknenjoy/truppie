class WelcomeController < ApplicationController
  
  def index
    @tours = Tour.publisheds.nexts
    @organizers = Organizer.all.order(created_at: :asc)
  end
  
  def organizer
     @organizer = Organizer.where(:user => current_user).take
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
