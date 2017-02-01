namespace :truppie do

  desc "Update fees"
  task update_order_fee: :environment do
     puts "Processando: #{Order.all.size} pagamentos"
     Order.all.each do |o|
       fee = o.update_fee
       if fee
         puts "The payment #{o.payment} is being processed with key #{o.to_param}"
         puts "The fee object is #{fee.inspect}"
         puts "Sucessully proccess the payment #{o.payment}"
       end
     end
  end
end