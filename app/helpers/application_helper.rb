module ApplicationHelper
  
  def flash_status(status)
    case status
    when 'error'
      {:className => 'danger', :label => 'ops!'}
    when 'notice'
      {:className => 'info', :label => 'hey!'}
    when 'success'
      {:className => 'success', :label => 'oba!'}
    else
      {:className => 'info', :label => 'aviso'}
    end
  end
  
  def friendly_when(t)
    if t > Time.now
      "daqui a #{time_ago_in_words(t)}"
    else
      "#{time_ago_in_words(t)} atrás"
    end
  end
  
  def friendly_price(p)
    if p > 0 
      number_to_currency(p.to_f/100, :unit => "R$")
    else
      number_to_currency(0, :unit => "R$", precision: 0)
    end
  end
  
  def final_price(p)
    "<small>R$</small> " + "<span>" + p.to_s + "</span>"
  end
  
end
