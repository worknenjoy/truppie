class WelcomeController < ApplicationController
  
  def index
    @tours = Tour.publisheds.nexts
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
