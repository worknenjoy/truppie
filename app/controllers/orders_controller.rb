require 'json'

class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :edit, :update, :destroy]
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
        target: 'http://www.truppie.com/webhook',
        media: "WEBHOOK"
      }
      
      response = RestClient.post "https://sandbox.moip.com.br/v2/preferences/notifications", post_params.to_json, :content_type => :json, :accept => :json, :authorization => Rails.application.secrets[:moip_auth] 
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
    puts 'someone post to webhook' 
    request_raw = request.raw_post()
    if !request_raw.empty?
      if request_raw.is_a? Hash
        request_raw_json = JSON.parse(request_raw.to_json)
      else
        request_raw_json = JSON.parse(request.raw_post())
      end
      
      @event = request_raw_json["event"]
        if !@event.empty?
          @payment_id = request_raw_json["resource"]["payment"]["id"]
          @payment_status = request_raw_json["resource"]["payment"]["status"]
          @status = request_raw_json["event"]
          
          order = Order.where(payment: @payment_id).joins(:user).take
          order_tour = Order.where(payment: @payment_id).joins(:tour).take
          user = order.user
          tour = order_tour.tour
          organizer = tour.organizer
          
          case @status
          when "PAYMENT.WAITING" 
              @subject = "Solicitação de reserva de uma truppie! :)"
              @guide_template = "status_change_guide_waiting"
              @mail_first_line = "Oba, que legal que você quer fazer a truppie #{tour.title} com o guia #{organizer.name}! :D"
              @mail_second_line = "Estamos aguardando o pagamento do seu cartão junto a operadora e, assim que for aprovado, vamos te avisar, ok?"
          when "PAYMENT.IN_ANALYSIS" 
              @subject = "Solicitação de reserva de uma truppie! :)"
              @guide_template = "status_change_guide_waiting"
              @mail_first_line = "Oba, que legal que você quer fazer a truppie #{tour.title} com o guia #{organizer.name}! :D"
              @mail_second_line = "O seu cartão de crédito encontra-se em análise junto à operadora e, assim que for aprovado, vamos te avisar, ok?"
          when "PAYMENT.PRE_AUTHORIZED"
              @subject = "Solicitação de reserva pré-autorizada de uma truppie! :)"
              @guide_template = "status_change_guide_waiting"
              @mail_first_line = "Oba, que legal que você quer fazer a truppie #{tour.title} com o guia #{organizer.name}! :D"
              @mail_second_line = "O seu cartão de crédito foi pré aprovado, assim que for aprovado, vamos te avisar, ok?"
          when "PAYMENT.AUTHORIZED"
              @subject = "A reserva de sua truppie está confirmada! :D"
              @guide_template = "status_change_guide_authorized"
              @mail_first_line = "Referente à solicitação de reserva da truppie #{tour.title} com o guia #{organizer.name}, boas novas: o pagamento foi autorizado pela operadora de seu cartão e sua truppie está oficialmente reservada! Uhuul \o/"
              @mail_second_line = "Agora basta aguardar o início do evento. Você pode acompanhá-lo em <a href='#{tour_url(tour)}'>#{tour_url(tour)}</a>"
          when 'PAYMENT.CANCELLED'
              @subject = "Ops, tivemos um probleminha na reserva da sua truppie :/"
              @guide_template = "status_change_guide_cancelled"
              @mail_first_line = "Referente à solicitação de reserva da truppie #{tour.title} com o guia #{organizer.name}, por algum motivo, a operadora do cartão de crédito recusou o pagamento e sua truppie não pode ser reservada ainda."
              @mail_second_line = "Queira por gentileza verificar em seu banco se há algum tipo de bloqueio ou problema com o cartão, e nos escreva para vermos como resolver: ola@truppie.com."
          when "PAYMENT.REVERSED"
              @subject = "Ops, tivemos um probleminha na reserva da sua truppie :/"
              @guide_template = "status_change_guide_cancelled"
              @mail_first_line = "Referente à solicitação de reserva da truppie #{tour.name} com o guia #{organizer.name}, por algum motivo, o seu pagamento foi estornado (O Estorno é a contestação do pagamento feita pelo comprador direto na operadora de cartão, como por exemplo pelo motivo de não reconhecimento do pagamento em sua fatura)."
              @mail_second_line = "Queira por gentileza verificar em seu banco se há algum tipo de bloqueio ou problema com o cartão, e nos escreva para vermos como resolver: ola@truppie.com."
          when "PAYMENT.REFUNDED"
              @subject = "Pedido de reembolso de uma truppie"
              @guide_template = "status_change_guide_refunded"
              @mail_first_line = "Referente à solicitação de reserva da truppie #{tour.title} com o guia #{organizer.name}, você será reembolsado."
              @mail_second_line = "Favor aguardar a próxima fatura do cartão o crédito referente a esta compra."
          when "PAYMENT.SETTLED"
              @subject = "Seu pagamento foi concluído"
              @guide_template = "status_change_guide_authorized"
              @mail_first_line = "Referente à solicitação de reserva da truppie #{tour.title} com o guia #{organizer.name}, o pagamento foi efetuado e concluído junto a operadora do seu cartão de crédito"
              @mail_second_line = "Agora basta aguardar o início do evento. Você pode acompanhá-lo em <a href='#{tour_url(tour)}'>#{tour_url(tour)}</a>"
          else
              @subject = "Não conseguimos obter o status junto a operadora"
              @guide_template = "status_change_guide_cancelled"
              @mail_first_line = "Referente à solicitação de reserva da truppie #{tour.title} com o guia #{organizer.name}, não tivemos uma atualização de status que pudéssemos indentificar."
              @mail_second_line = "Queira por gentileza verificar em seu banco se há algum tipo de bloqueio ou problema com o cartão, e nos escreva para vermos como resolver: ola@truppie.com."
          end 
          
          is_in_the_history = order.status_history.include?(@status)
          
          if !is_in_the_history
            
            order.status_history <<  @status
            
            if order.save()
              puts "Pedido de pagamento #{order.payment} atualizado com sucesso"
            end
            
            @status_data = {
              subject: @subject,
              mail_first_line: @mail_first_line,
              mail_second_line: @mail_second_line,
              guide: @guide_template
            }
            CreditCardStatusMailer.status_change(@status_data, order, user, tour, organizer).deliver_now
            CreditCardStatusMailer.guide_mail(@status_data, order, user, tour, organizer).deliver_now
          else
            puts 'O webhook do moip tentou enviar uma notificação repetida'
          end
        else
          CreditCardStatusMailer.status_message('erro ao tentar processar o request').deliver_now
        end
    else
      CreditCardStatusMailer.status_message('alguem postou no webhook sem os dados do Moip').deliver_now       
    end
    render nothing: true
  end
  
  # GET /orders
  # GET /orders.json
  def index
    @orders = current_user.orders
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
