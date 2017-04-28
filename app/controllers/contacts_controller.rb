class ContactsController < ApplicationController
  
  def index
    
  end
  
  
  def send_form
    if params[:email].empty? or params[:body].empty? 
      flash[:error] = t('contacts_controller_error')
    else
      if ContactMailer.send_form(params).deliver_now
        flash[:success] = t('contacts_controller_succes')
      else
         flash[:error] = t('contacts_controller_error_two') 
      end
    end
    redirect_to contacts_index_path
  end
end
