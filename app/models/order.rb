require 'json'
require 'rest_client'

class Order < ActiveRecord::Base
  belongs_to :tour
  belongs_to :user
  
  def to_param
    "#{id} #{self.payment}".parameterize
  end
  
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
  
  def update_fee
    headers = {
      :content_type => 'application/json',
      :authorization => Rails.application.secrets[:moip_auth]
    }
    RestClient.get("#{Rails.application.secrets[:moip_domain]}/payments/#{self.payment}", headers){|response, request, result, &block|
      case response.code
        when 200 || 203
          json_data = JSON.parse(response)
          if json_data.nil?
            false
          elsif json_data["status"] == "AUTHORIZED" || json_data["status"] == "SETTLED"
            {
              fee: json_data["amount"]["fees"],
              liquid: json_data["amount"]["liquid"],
              total: json_data["amount"]["total"]
            }
          else
            {
              fee: 0,
              liquid: 0,
              total: 0
            }
          end
        when 404
          puts response.inspect
          json_data = JSON.parse(response)
        else
          puts response.inspect
          json_data = JSON.parse(response)
        end
    }
  end
  
  def fees
    fees_json = $redis.get(self.to_param) 
    if fees_json.nil?
      self.update_fee  
    end
    JSON.parse fees_json
  end
  
  def settled
    headers = {
      :content_type => 'application/json',
      :authorization => Rails.application.secrets[:moip_auth]
    }
    response = ::RestClient.get "#{Rails.application.secrets[:moip_domain]}/payments/#{self.payment}", headers
    json_data = JSON.parse(response)
    
    if json_data.nil?
      false
    elsif json_data["status"] == "SETTLED"
      {
        fee: json_data["amount"]["fees"],
        liquid: json_data["amount"]["liquid"],
        total: json_data["amount"]["total"]
      }
    else
      {
        fee: 0,
        liquid: 0,
        total: 0
      }
    end
  end
  
  def total_fee
    self.fees[:fee]
  end
  
  def amount_total
    self.fees[:total]
  end
  
  def price_with_fee
    self.fees[:liquid]
  end
  
  def available_liquid
    self.settled[:liquid]
  end
  
  def available_total
    self.settled[:total]
  end
  
  def available_with_taxes
    self.settled[:fee]
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
