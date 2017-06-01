require 'json'

class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, :except => [:new_webhook, :webhook]
  skip_before_action :verify_authenticity_token
  
  def new_webhook
    if params[:webhook_type] == 'default'
      
      headers = {
        :content_type => 'application/json',
        :authorization => Rails.application.secrets[:moip_auth]
      }
      
      post_params = {
        events: [
          "PAYMENT.*"
        ],
        target: "#{request.domain}/webhook",
        media: "WEBHOOK"
      }
      base_url = Rails.application.secrets[:moip_domain]
      
      response = RestClient.post "#{base_url}/preferences/notifications", post_params.to_json, :content_type => :json, :accept => :json, :authorization => Rails.application.secrets[:moip_auth] 
      json_data = JSON.parse(response)
      
      if json_data["id"]
        flash[:success] = 'webhook padrao criado com sucesso'
        @webhook_id = json_data["id"]
        @webhook_return_url = json_data["target"]
      else
        flash[:error] = 'Nao foi possivel criar webhook'      
      end
    else
      flash[:error] = 'voce precisa definir o tipo de webhook que voce ira enviar'
    end
  end
    
  def webhook
    request_raw = request.raw_post()
    #puts request_raw
    if !request_raw.empty?
      if request_raw.is_a? Hash
        request_raw_json = JSON.parse(request_raw.to_json)
      else
        request_raw_json = JSON.parse(request.raw_post())
      end
      
      #puts "webhook"
      #puts request_raw_json.inspect
      
      @event = request_raw_json["type"]
      @user_id = request_raw_json["user_id"]


      @event_types = ["stripe_account", "review.closed", "transfer.created", "transfer.updated", "charge.succeeded", "charge.pending", "charge.failed", "payment.created"]

      if @event_types.include?(@event)
        
        @payment_id = request_raw_json["data"]["object"]["id"]
        @status = request_raw_json["data"]["object"]["status"]
        @destination = request_raw_json["data"]["object"]["destination_payment"]
        
        @transfer = request_raw_json["source_transaction"] || request_raw_json["data"]["object"]["source_transaction"]
        
        @reviewed = request_raw_json["data"]["object"]["charge"]
        
        if @transfer
          @payment_id = @transfer
          if @status == "paid"
            @status = "succeeded"
          end
        end
        
        if @reviewed
          @payment_id = @reviewed 
          @status = request_raw_json["data"]["object"]["reason"]
          if @status == "approved"
            @status = "succeeded"
          end
        end

        @amount_to_transfer = request_raw_json["data"]["object"]["amount"]
        @type_of_action = request_raw_json["data"]["object"]["object"]
        @transfer_status = request_raw_json["data"]["object"]["status"]


        if @user_id && @type_of_action == 'transfer'
          @marketplace_organizer = Marketplace.where(:account_id => @user_id).first

          @marketplace_organizer_owner = request_raw_json["data"]["object"]["bank_account"]["account_holder_name"]
          @marketplace_organizer_bankname = request_raw_json["data"]["object"]["bank_account"]["bank_name"]
          @marketplace_organizer_banknumber = request_raw_json["data"]["object"]["bank_account"]["last4"]

          case @transfer_status
          when 'in_transit'
            @status_class = "alert-success"
            @subject = "Uma nova transferência a caminho"
            @mail_first_line = "Uma nova transferência foi solicitada para #{@marketplace_organizer_owner}"
            @mail_second_line = "Uma transferência no valor de <strong>#{final_price_from_cents(@amount_to_transfer)}</strong> está em andamento para sua conta <br /> no banco #{@marketplace_organizer_bankname} de número ****#{@marketplace_organizer_banknumber} e avisaremos quando for concluída"
          when 'paid'
            @status_class = "alert-success"
            @subject = "Uma nova transferência foi realizada para sua conta"
            @mail_first_line = "Uma nova transferência foi realizada para #{@marketplace_organizer_owner}"
            @mail_second_line = "Uma transferência no valor de <strong>#{final_price_from_cents(@amount_to_transfer)}</strong> foi concluída para sua conta <br /> no banco #{@marketplace_organizer_bankname} de número ****#{@marketplace_organizer_banknumber}"
          else
            @status_class = "alert-success"
            @subject = "Uma nova transferência a caminho"
            @mail_first_line = "Uma nova transferência foi solicitada para #{@marketplace_organizer_owner}"
            @mail_second_line = "Uma transferência no valor de <strong>#{final_price_from_cents(@amount_to_transfer)}</strong> está em andamento para sua conta <br /> no banco #{@marketplace_organizer_bankname} de número ****#{@marketplace_organizer_banknumber}"
          end



          @status_data = {
              subject: @subject,
              mail_first_line: @mail_first_line,
              mail_second_line: @mail_second_line,
              status_class: @status_class
          }
          transfer_mail = TransferMailer.transfered(@marketplace_organizer.organizer, @status_data).deliver_now
          return :success

        end
        
        begin
          order = Order.where(payment: @payment_id).joins(:user).take
          if !order.try(:status)
            order.update_attributes({:status => @status})
          end
          if @destination
            order.update_attributes({:destination => @destination})
          end
          order_tour = Order.where(payment: @payment_id).joins(:tour).take
          user = order.user
          tour = order_tour.tour
          organizer = tour.organizer
        rescue => e
           CreditCardStatusMailer.status_message("Pagamento não encontrado. Webhook recebido #{request_raw_json}").deliver_now
           return :bad_request        
        end
        
        case @status
        when "pending"
            @status_class = "alert-success"
            @subject = "Solicitação de reserva de uma truppie! :)"
            @guide_template = "status_change_guide_waiting"
            @mail_first_line = "Oba, que legal que você quer fazer a truppie #{tour.title} com o guia #{organizer.name}! :D"
            @mail_second_line = "Estamos aguardando o pagamento do seu cartão junto a operadora e, assim que for aprovado, vamos te avisar, ok?"
        when "succeeded"
            @status_class = "alert-success" 
            @subject = "Solicitação de reserva de uma truppie! :)"
            @guide_template = "status_change_guide_authorized"
            @mail_first_line = "Referente à solicitação de reserva da truppie <strong>#{tour.title}</strong> com o guia <strong>#{organizer.name}</strong>, <br />temos boas novas: o pagamento foi <strong>autorizado</strong> pela operadora de seu cartão e sua truppie está <strong>oficialmente reservada!</strong> Uhuul \o/ "
            @mail_second_line = "Você está confirmado no evento. <br />Qualquer dúvida, você pode entrar em contato diretamente pelo e-mail <a href='#{organizer.email}'>#{organizer.email}</a>."
        when "failed"
            @status_class = "alert-danger"
            @subject = "Ops, tivemos um probleminha na reserva da sua truppie :/"
            @guide_template = "status_change_guide_cancelled"
            @mail_first_line = "Referente à solicitação de reserva da truppie #{tour.title} com o guia #{organizer.name}, por algum motivo, a operadora do cartão de crédito recusou o pagamento e sua truppie não pode ser reservada ainda."
            @mail_second_line = "Queira por gentileza verificar em seu banco se há algum tipo de bloqueio ou problema com o cartão, e nos escreva para vermos como resolver: ola@truppie.com."
        else
            @status_class = "alert-warning"
            @subject = "Não conseguimos obter o status junto a operadora"
            @guide_template = "status_change_guide_cancelled"
            @mail_first_line = "Referente à solicitação de reserva da truppie #{tour.title} com o guia #{organizer.name}, não tivemos uma atualização de status que pudéssemos indentificar."
            @mail_second_line = "Queira por gentileza verificar em seu banco se há algum tipo de bloqueio ou problema com o cartão, e nos escreva para vermos como resolver: ola@truppie.com."
        end 
        
        is_in_the_history = order.status_history.include?(@status)
        
        is_status_to_ignore = ['pending'].include?(@status)
        
        if !is_in_the_history
          
          order.status_history <<  @status
          
          if order.save()
            #puts "Pedido de pagamento #{order.payment} atualizado com sucesso"
            if @status == 'failed'
              t = tour.confirmeds.where(:user => user).delete_all
              #puts "Usuario #{t} desconfirmado com sucesso"
            end
          end
          if !is_status_to_ignore
            @status_data = {
              subject: @subject,
              mail_first_line: @mail_first_line,
              mail_second_line: @mail_second_line,
              status_class: @status_class,
              guide: @guide_template
            }
            mail = CreditCardStatusMailer.status_change(@status_data, order, user, tour, organizer).deliver_now
            guide_mail = CreditCardStatusMailer.guide_mail(@status_data, order, user, tour, organizer).deliver_now
            if !mail
              CreditCardStatusMailer.status_message('não foi possível enviar os e-mails aos usuários e guias').deliver_now
            end
          else
            CreditCardStatusMailer.status_message("O usuario #{user.name} esta com o status #{@status}").deliver_now
          end
        else
          puts 'O webhook tentou enviar uma notificação repetida'
        end
      else
        CreditCardStatusMailer.status_message('erro ao tentar processar o request').deliver_now
      end
    else
      CreditCardStatusMailer.status_message('alguem postou no webhook sem os dados').deliver_now       
    end
    render layout: false
    return :success
  end
  
  # GET /orders
  # GET /orders.json
  def index
    @orders = current_user.orders.order('created_at DESC')
  end

  # GET /orders/1
  # GET /orders/1.json
  def show
    
  end

  # GET /orders/new
  def new
    @order = Order.new
  end

  # GET /orders/1/edit
  def edit
  end

  # POST /orders
  # POST /orders.json
  def create
    @order = Order.new(order_params)

    respond_to do |format|
      if @order.save
        format.html { redirect_to @order, notice: 'Order was successfully created.' }
        format.json { render :show, status: :created, location: @order }
      else
        format.html { render :new }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /orders/1
  # PATCH/PUT /orders/1.json
  def update
    respond_to do |format|
      if @order.update(order_params)
        format.html { redirect_to @order, notice: 'Order was successfully updated.' }
        format.json { render :show, status: :ok, location: @order }
      else
        format.html { render :edit }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /orders/1
  # DELETE /orders/1.json
  def destroy
    @order.destroy
    respond_to do |format|
      format.html { redirect_to orders_url, notice: 'Order was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def order_params
      params.require(:order).permit(:own_id, :tour_id, :user_id, :status, :price, :discount)
    end
end
