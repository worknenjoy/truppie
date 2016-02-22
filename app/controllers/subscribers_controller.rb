class SubscribersController < ApplicationController
  def create
    
    #puts '------'
    #puts params[:subscriber]['email']
    #puts '------'
    
    if params[:subscriber]['email'] == ''
      flash[:error] = "You should fill with your email"
    else
       @subscriber = Subscriber.new(email: params[:subscriber]['email'])
       if @subscriber.save
          flash[:notice] = "Subscriber was recorded"
       end 
    end
  end
end
