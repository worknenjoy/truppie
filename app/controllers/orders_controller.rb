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
          "ORDER.*",
          "PAYMENT.AUTHORIZED",
          "PAYMENT.CANCELLED",
          "PAYMENT.IN_ANALYSIS"
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
    puts request.raw_post().inspect
    request_raw = request.raw_post()
    if !request_raw.empty?
      @event = request_raw[:event]
        if !@event.empty?
          @payment_id = @friendly_status = request_raw[:resource][:payment][:id]
          @friendly_status = request_raw[:resource][:payment][:status]
          case @friendly_status
          when 'CREATED'
            @status = 'O seu pagamento foi processado'
          when 'WAITING'
            @status = 'Recebemos o seu pagamento e estamos aguardando o contato da operadora do cartão com uma resposta'
          when 'IN_ANALYSIS'
            @status = 'O seu pagamento se encontra em análise pela operadora do cartão'
            @subject = "Solicitação de reserva de uma truppie! :)"
          when 'PRE_AUTHORIZED'
            @status = 'O seu pagaemento foi pré-autorizado'
          when 'AUTHORIZED'
            @status = 'O seu pagamento foi autorizado'
          when 'CANCELLED'
            @status = 'O seu pagamento foi cancelado pela operadora do cartão'
          when 'REVERSED'
            @status = 'O seu pagamento foi revertido'
          when 'REFUNDED'
            @status = 'Você irá ser reembolsado'
          when 'SETTLED'
            @status = 'O seu pagamento se encontra em negociação'
          else
            'Estamos ainda definindo o status do seu pagamento'
          end 
          order = Order.where(payment: @payment_id).joins(:user).take
          order_tour = Order.where(payment: @payment_id).joins(:tour).take
          user = order.user
          tour = order_tour.tour
          organizer = tour.organizer
          
          @status_data = {
            subject: @subject,
            content: @status
          }
           
          CreditCardStatusMailer.status_change(@status_data, user, tour, organizer).deliver_now
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
