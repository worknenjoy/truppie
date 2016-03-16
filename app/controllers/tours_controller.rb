class ToursController < ApplicationController
  before_action :set_tour, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, :except => [:show, :index]

  def confirm
    @tour = Tour.find(params[:id])
  end
  
  def confirm_presence
    @tour = Tour.find(params[:id])
    @payment_data = params[:payment]
    
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
              detail: @tour.description,
              price: @tour.value.to_i
            }
          ],
          customer: {
            own_id: "#{current_user.id.to_s}_#{current_user.name.parameterize}",
            fullname: current_user.name,
            email: current_user.email
          } 
        })
        if not @payment_data.nil?
          payment = api.payment.create(order.id,
              {
                  installment_count: 1,
                  funding_instrument: {
                      method: "CREDIT_CARD",
                      credit_card: {
                          expiration_month: 04,
                          expiration_year: 18,
                          number: "4012001038443335",
                          cvc: "123",
                          holder: {
                              fullname: current_user.name,
                              birthdate: "1988-10-10",
                              tax_document: {
                                  type: "CPF",
                                  number: "22222222222"
                          },
                              phone: {
                                  country_code: "55",
                                  area_code: "11",
                                  number: "55667788"
                              }
                          }
                      }
                  }
              }
          )
          @tour.confirmeds.create(:user  => current_user)
            if @tour.save() and payment.success?
              flash[:success] = "Presence Confirmed!"
              redirect_to @tour
            else
              flash[:error] = "It now was possible confirm this user"
              redirect_to @tour
            end
        else
          flash[:error] = "No payment information supplied"
          redirect_to @tour
        end
      else
        flash[:error] = "this event is soldout"
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
