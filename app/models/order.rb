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
    
    response = ::RestClient.get "#{Rails.application.secrets[:moip_domain]}/payments/#{payment_id}", headers
    json_data = JSON.parse(response)
    self.update_attributes({:status => json_data["status"]})
    json_data["status"]
    
  end
  
  def payment_link
    "https://checkout.moip.com.br/boleto/#{self.payment}"
  end
  
  def fees
    headers = {
      :content_type => 'application/json',
      :authorization => Rails.application.secrets[:moip_auth]
    }
    response = ::RestClient.get "#{Rails.application.secrets[:moip_domain]}/payments/#{self.payment}", headers
    json_data = JSON.parse(response)
    
    logger.debug json_data.inspect
    
    if json_data.nil?
      false  
    end
    {
      fee: json_data["amount"]["fees"],
      liquid: json_data["amount"]["liquid"],
      total: json_data["amount"]["total"]
    }
  end
  
  def total_fee
    self.fees[:fee]
  end
  
  def price_with_fee
    self.fees[:liquid]
  end
  
  def full_desc_status(status)
    case status
    when 'CREATED'
      'O seu pagamento foi processado'
    when 'WAITING'
      'Recebemos o seu pagamento e estamos aguardando o contato da operadora do cartão com uma resposta'
    when 'IN_ANALYSIS'
      'O seu pagamento se encontra em análise pela operadora do cartão'
    when 'PRE_AUTHORIZED'
      'O seu pagaemento foi pré-autorizado'
    when 'AUTHORIZED'
      'O seu pagamento foi autorizado'
    when 'CANCELLED'
      'O seu pagamento foi cancelado pela operadora do cartão'
    when 'REVERSED'
      'O seu pagamento foi revertido'
    when 'REFUNDED'
      'Você irá ser reembolsado'
    when 'SETTLED'
      'O seu pagamento foi finalizado'
    else
      'Estamos ainda definindo o status do seu pagamento'
    end
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
      '<span class="label label-warning">FINALIZADO</span>'
    else
      '<span class="label label-default">NAO DEFINIDO</span>'
    end
    
  end
  
end
