class ToursController < ApplicationController
  before_action :set_tour, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, :except => [:show, :index]

  def confirm
    @tour = Tour.find(params[:id])
  end
  
  def confirm_presence
    @tour = Tour.find(params[:id])
    @payment_data = {
      method: params[:method],
      expiration_month: params[:expiration_month],
      expiration_year: params[:expiration_year],
      number: params[:number],
      cvc: params[:cvc],
      fullname: params[:fullname],
      birthdate: params[:birthdate],
      cpf_number: params[:cpf_number],
      country_code: params[:country_code],
      area_code: params[:area_code],
      phone_number: params[:phone_number]
      
    }
    
    if @tour.confirmeds.exists?(user: current_user)
      flash[:error] = "Hey, you already confirmed this event!!"
      redirect_to @tour          
    else
      if !@tour.soldout?
        auth = Moip2::Auth::Basic.new(Rails.application.secrets[:moip_token], Rails.application.secrets[:moip_key])
        client = Moip2::Client.new(:sandbox, auth)
        api = Moip2::Api.new(client)
        
        order = api.order.create({
          own_id: "truppie_#{@tour.id}_#{current_user.id}",
          items: [
            {
              product: @tour.title,
              quantity: 1,
              detail: @tour.description.first(250),
              price: @tour.value.to_i * 100
            }
          ],
          customer: {
            own_id: "#{current_user.id.to_s}_#{current_user.name.parameterize}",
            fullname: current_user.name,
            email: current_user.email
          } 
        })
        if not @payment_data[:fullname].nil?
          payment = api.payment.create(order.id,
              {
                  installment_count: 1,
                  funding_instrument: {
                      method: @payment_data[:method],
                      credit_card: {
                          expiration_month: @payment_data[:expiration_month],
                          expiration_year: @payment_data[:expiration_year],
                          number: @payment_data[:number],
                          cvc: @payment_data[:cvc],
                          holder: {
                              fullname: @payment_data[:fullname],
                              birthdate: @payment_data[:birthdate].to_date.strftime('%Y-%m-%d'),
                              tax_document: {
                                  type: "CPF",
                                  number: @payment_data[:cpf_number]
                          },
                              
                        }
                      }
                  }
              }
          )
          @tour.confirmeds.new(:user  => current_user)
          if payment.success?
            @order = Order.create(
              :source_id => order.id,
              :own_id => "truppie_#{@tour.id}_#{current_user.id}",
              :user => current_user,
              :tour => @tour,
              :status => payment.status,
              :payment => payment.id,
              :price => @tour.value.to_i * 100
            )
            if @order.save() and @tour.save()
              flash[:success] = "Presença confirmada! Você pode acompanhar o status em Minhas Reservas"
              flash[:order_id] = order.id
              redirect_to @tour
            else
              flash[:error] = "Nao foi possivel criar seu pedido de numero #{order.id}"
              redirect_to @tour
            end
          else
            flash[:error] = payment.errors[0].description
            redirect_to @tour
          end
        else
          flash[:error] = "Não foi informado informações sobre o pagamento"
          redirect_to @tour
        end
      else
        flash[:error] = "Este evento está esgotado"
        redirect_to @tour
      end 
    end
  end
  
  def unconfirm_presence
    @tour = Tour.find(params[:id])
    if @tour.confirmeds.where(user: current_user).delete_all
      flash[:success] = "you were successfully unconfirmed to this tour"
    else
      flash[:error] = "it was not possible unconfirm"
    end
    redirect_to @tour
  end

  # GET /tours
  # GET /tours.json
  def index
    @tours = Tour.all
  end

  # GET /tours/1
  # GET /tours/1.json
  def show
    
  end

  # GET /tours/new
  def new
    @tour = Tour.new
  end

  # GET /tours/1/edit
  def edit
  end

  # POST /tours
  # POST /tours.json
  def create
    @tour = Tour.new(tour_params)

    respond_to do |format|
      if @tour.save
        format.html { redirect_to @tour, notice: 'Tour was successfully created.' }
        format.json { render :show, status: :created, location: @tour }
      else
        format.html { render :new }
        format.json { render json: @tour.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tours/1
  # PATCH/PUT /tours/1.json
  def update
    respond_to do |format|
      if @tour.update(tour_params)
        format.html { redirect_to @tour, notice: 'Tour was successfully updated.' }
        format.json { render :show, status: :ok, location: @tour }
      else
        format.html { render :edit }
        format.json { render json: @tour.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tours/1
  # DELETE /tours/1.json
  def destroy
    @tour.destroy
    respond_to do |format|
      format.html { redirect_to tours_url, notice: 'Tour was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_tour
    @tour = Tour.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def tour_params
    params.fetch(:tour, {})
  end
end
