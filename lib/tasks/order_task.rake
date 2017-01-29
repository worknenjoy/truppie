namespace :truppie do

  desc "Update fees"
  task update_order_fee: :environment do
     puts "Processando: #{Order.all.size} pagamentos"
     Order.all.each do |o|
       if o.update_fee
         puts o.payment.inspect
         puts "sucesso para processar o pagamento #{o.payment}"
       end
     end
  end
end