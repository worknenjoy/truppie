class ContactsController < ApplicationController

  def index

  end


  def send_form
    if params[:email].empty? or params[:body].empty?
      flash[:error] = t('contacts_controller_error')
    else
      if ContactMailer.send_form(params).deliver_now
        sign_in_mailchimp params[:email]
        flash[:success] = t('contacts_controller_succes')
      else
         flash[:error] = t('contacts_controller_error_two')
      end
    end
    redirect_to contacts_index_path
  end

  def send_message
    if params[:body].empty?
      flash[:error] = t('contacts_controller_error')
    else
      if ContactMailer.send_message(params).deliver_now
        flash[:success] = t('contacts_controller_succes')
      else
         flash[:error] = t('contacts_controller_error_two')
      end
    end
  end

  def sign_in_mailchimp email
    if Rails.application.secrets[:mailchimp_api_key]
      begin
        gibbon = Gibbon::Request.new(api_key: Rails.application.secrets[:mailchimp_api_key],
                                     symbolize_keys: true)
        gibbon.timeout = 10
        gibbon.lists(Rails.application.secrets[:mailchimp_list_id_user]).members
              .create(body: { email_address: email,
                              status: 'subscribed' })
      rescue Gibbon::MailChimpError => e
        puts "Email já cadastrado ou inválido: #{email}"
      end
    end
  end
end
