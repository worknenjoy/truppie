class ContactsController < ApplicationController
  
  def index
    
  end
  
  
  def send_form
    if params[:email].empty? or params[:body].empty? 
      flash[:error] = 'Faltou preencher o email e/ou a mensagem'
    else
      if ContactMailer.send_form(params).deliver_now
        flash[:success] = 'Sua mensagem foi enviada com sucesso, entraremos em contato em breve'
      else
         flash[:error] = 'Não foi possível enviar o seu e-mail. Tente novamente' 
      end
    end
    redirect_to contacts_index_path
  end
end
