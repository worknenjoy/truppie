class SubscribersController < ApplicationController
  def create
    @subscriber = Subscriber.new(params.require(:subscriber).permit(:email))
    
    if !@subscriber.valid?
      flash[:error] = @subscriber.errors.messages[:email][0]
      redirect_to root_path
    else
       if @subscriber.save
          flash[:success] = "Subscriber was recorded"
          redirect_to root_path
       end 
    end
  end
end
