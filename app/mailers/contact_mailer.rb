class ContactMailer < ApplicationMailer
  def send_form(params)
    mail(from: params[:email], subject: params[:subject], body: "#{params[:name]} enviou \n #{params[:body]}", to: 'ola@truppie.com')
  end
end
