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
  
  desc "send webhook email for charge"
  task send_email: :environment do
     puts "enviando e-mail:"
     
     @post_params = {
      "id": "evt_19qSuHBrSjgsps2DD5DiwGT5",
      "object": "event",
      "created": 1487880581,
      "data": {
        "object": 
          {
            "id": "ch_19qSuIBrSjgsps2DCXDNuqsD",
            "object": "charge",
            "amount": 100,
            "amount_refunded": 0,
            "balance_transaction": "txn_19qSuIBrSjgsps2Dt2PoMOeB",
            "captured": true,
            "created": 1487880582,
            "currency": "usd",
            "description": "My First Test Charge (created for API docs)",
            "fraud_details": {},
            "livemode": false,
            "metadata": {},
            "outcome": {
              "network_status":"approved_by_network",
              "reason":"denied",
              "risk_level":"normal",
              "seller_message":"Payment complete.",
              "type":"authorized"
            },
            "paid": true,
            "refunded": false,
            "source": {
              "id": "card_19qSqOBrSjgsps2DxBs2TaNd",
              "object": "card",
              "brand": "Visa",
              "country": "US",
              "exp_month": 8,
              "exp_year": 2018,
              "funding": "credit",
              "last4": "4242",
              "metadata": {},
            },
            "status": "succeeded",
          }
      },
      "type": "charge.succeeded"
    }
    orders = Order.create(:status => 'succeeded', :price => 200, :final_price => 200, :payment => "evt_19qSuHBrSjgsps2DD5DiwGT5", :user => User.last, :tour => Tour.last)
    #request.env['RAW_POST_DATA'] = @post_params
    post webhook_url, {} 
  end
end