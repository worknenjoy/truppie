require 'json'
require 'rest_client'

class Order < ActiveRecord::Base
  belongs_to :tour
  belongs_to :user
  
  
  def current_status
    payment_id = self.payment
    
    headers = {
      :content_type => 'application/json',
      :authorization => Rails.application.secrets[:moip_auth]
    }
    
    response = ::RestClient.get "https://sandbox.moip.com.br/v2/payments/#{payment_id}", headers
    json_data = JSON.parse(response)
    json_data["status"]
    
  end
  
  def friendly_status(status)
    case status
    when 'CREATED'
      '<span class="label label-default">CRIADO</span>'
    when 'WAITING'
      '<span class="label label-primary">AGUARDANDO</span>'
    when 'IN_ANALYSIS'
      '<span class="label label-primary">EM ANALISE</span>'
    when 'PRE_AUTHORIZED'
      '<span class="label label-info">PRE-AUTORIZADO</span>'
    when 'AUTHORIZED'
      '<span class="label label-success">AUTORIZADO</span>'
    when 'CANCELLED'
      '<span class="label label-danger">CANCELADO</span>'
    when 'REVERSED'
      '<span class="label label-warning">REVERTIDO</span>'
    when 'REFUNDED'
      '<span class="label label-warning">REEMBOLSADO</span>'
    when 'SETTLED'
      '<span class="label label-warning">EM NEGOCIACAO</span>'
    else
      '<span class="label label-default">NAO DEFINIDO</span>'
    end
    
  end
  
end
