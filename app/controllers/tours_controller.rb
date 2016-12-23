class ToursController < ApplicationController
  before_action :set_tour, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, :except => [:show]
  before_filter :check_if_admin, only: [:index, :new, :create, :update]
  
  def check_if_admin
    
    allowed_emails = ["laurinha.sette@gmail.com", "alexanmtz@gmail.com"]
    
    unless allowed_emails.include? current_user.email
      flash[:notice] = "Você não está autorizado a entrar nesta página"
      redirect_to root_url
    end 
  end

  def confirm
    @tour = Tour.find(params[:id])
    @packagename = params[:packagename]
    
    if @tour.value
      @final_price = @tour.value
    else
      if @packagename
        @final_price = @tour.packages.find_by_name(@packagename).value
      else
        @final_price = false
      end      
    end
  end
  
  def confirm_presence
    @tour = Tour.find(params[:id])
    @value = params[:value].to_i
    
    @payment_method = params[:method]
    
    if params[:amount].nil? || params[:amount].empty?
      @amount = 1
    else
      @amount = params[:amount].to_i
    end
    
    if params[:final_price].nil? || params[:final_price].empty?
      @final_price = @value
    else
      @final_price = params[:final_price].to_i      
    end
    
    @payment_data = {
      method: @payment_method,
      expiration_month: params[:expiration_month],
      expiration_year: params[:expiration_year],
      number: params[:number],
      cvc: params[:cvc],
      fullname: params[:fullname],
      birthdate: params[:birthdate],
      cpf_number: params[:cpf_number],
      country_code: params[:country_code],
      area_code: params[:area_code],
      phone_number: params[:phone_number],
      installment_count: params[:installment_count]
    }
    
    
    if @payment_method == "BOLETO"
      
      payment_object_type = {
         funding_instrument: {
           method: @payment_data[:method],
           boleto: {
             expirationDate: (@tour.start - 72.hours).strftime('%Y-%m-%d'),
             instructionLines: {
                first: @tour.title,
                second: @tour.organizer.name,
                third: "Reservado por #{current_user.name}"
              }
            }
          } 
        }
    elsif @payment_method == "CREDIT_CARD" && !@payment_data[:birthdate].nil?
        payment_object_type = {
            installment_count: @payment_data[:installment_count] || 1,
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
                    }
                        
                  }
                }
              }
          }
    else
      payment_object_type = {}
    end
    
    if @tour.confirmeds.exists?(user: current_user)
      flash[:error] = "Hey, você já está confirmado neste evento!!"
      redirect_to @tour          
    else
      if !@tour.soldout?
        auth = Moip2::Auth::Basic.new(Rails.application.secrets[:moip_token], Rails.application.secrets[:moip_key])
        client = Moip2::Client.new(Rails.application.secrets[:moip_env], auth)
        api = Moip2::Api.new(client)
        
        order = api.order.create({
          own_id: "truppie_#{@tour.id}_#{current_user.id}",
          items: [
            {
              product: @tour.title,
              quantity: @amount,
              detail: @tour.description.first(250),
              price: @value * 100
            }
          ],
          customer: {
            own_id: "#{current_user.id.to_s}_#{current_user.name.parameterize}",
            fullname: current_user.name,
            email: current_user.email
          } 
        })
        if not @payment_data[:method].nil?
          payment = api.payment.create(order.id, payment_object_type)
          
          if payment.try(:errors)
            @payment_api_error = payment["errors"][0]["path"]
          else
            if @payment_method == "BOLETO"
              @payment_api_success = payment
              @payment_api_success_url = @payment_api_success[:_links][:pay_boleto][:redirect_href]
            end
            
          end
          
          if payment.success? && !@payment_method.nil?
            
            @tour.confirmeds.new(:user  => current_user)
          
            amount_reserved_now = @tour.reserved
            @reserved_increment = amount_reserved_now + @amount         
            @tour.update_attributes(:reserved => @reserved_increment)
            
            @order = @tour.orders.create(
              :source_id => order.id,
              :own_id => "truppie_#{@tour.id}_#{current_user.id}",
              :user => current_user,
              :tour => @tour,
              :status => payment.status,
              :payment => payment.id,
              :price => @value,
              :amount => @amount,
              :final_price => @final_price,
              :payment_method => @payment_method
            )
            
            if @tour.save()
              #flash[:order_id] = order.id
              @confirm_headline_message = "Sua presença foi confirmada para a truppie"
              @confirm_status_message = "Você receberá um e-mail sobre o processamento do seu pagamento"
              @status = "success"
              if @payment_method == "BOLETO"
                @payment_link = @payment_api_success_url
              end
            else
              @confirm_headline_message = "Não foi possível confirmar sua reserva"
              @confirm_status_message = "Houve um problema com o seu pagamento"
              if @payment_api_error
                @confirm_status_message = "Houve um problema com o seu pagamento: #{@payment_api_error}"
              end
              
              @status = "danger"
            end
          else
            @confirm_headline_message = "Não foi possível confirmar sua reserva"
            @confirm_status_message = payment.errors[0].description
            @status = "danger"
            ContactMailer.notify("O usuário #{current_user.name} do email #{current_user.email} tentou efetuar o pagamento e o moip retornou #{payment.errors.inspect}").deliver_now
            ContactMailer.notify("O usuário #{current_user.name} do email #{current_user.email} tentou efetuar o pagamento mas não foi possível devido a: #{@payment_api_error}", @tour).deliver_now
          end
        else
          @confirm_headline_message = "Não foi possível confirmar sua reserva"
          @confirm_status_message = "Você não forneceu dados suficientes para o pagamento"
          @status = "danger"
          ContactMailer.notify("O usuário #{current_user.name} do email #{current_user.email} tentou efetuar o pagamento sem fornecer as informações").deliver_now
        end
      else
        @confirm_headline_message = "Não foi possível confirmar sua reserva"
        @confirm_status_message = "Este evento está esgotado"
        @status = "danger"
        redirect_to @tour
      end 
    end
  end
  
  def confirm_presence_alt
    @confirm_headline_message = "Evento confirmado com sucesso"
    @confirm_status_message = "Obrigado por se inscrever neste evento"
    @status = "success"
    @tour = Tour.last
    @order = current_user.orders.last
    @amount = 2
    @final_price = 80
    @payment_method = "BOLETO"
    @payment_link = "https://checkout-sandbox.moip.com.br/boleto/#{@order.payment}"
    render 'confirm_presence'
  end
  
  def unconfirm_presence
    @tour = Tour.find(params[:id])
    @order = current_user.orders.where(:tour => @tour).first
    reserveds = @tour.reserved
    if @tour.confirmeds.where(user: current_user).delete_all
      @tour.update_attributes(:reserved => reserveds - @order.amount)
      flash[:success] = "Você não está mais confirmardo neste evento"
    else
      flash[:error] = "Houve um problema com sua confirmação para este evento"
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
    #puts tour_params.inspect
    @tour = Tour.new(tour_params)
    
    respond_to do |format|
      if @tour.save
        format.html { redirect_to @tour, notice: 'Truppie criada com sucesso' }
        format.json { render :show, status: :created, location: @tour }
      else
        format.html { redirect_to tours_path, notice: "o campo #{@tour.errors.first[0]} #{@tour.errors.first[1]}" }
        format.json { render json: @tour.errors, status: :unprocessable_entity }
      end
    end
    #redirect_to tours_path
  end

  # PATCH/PUT /tours/1
  # PATCH/PUT /tours/1.json
  def update
    respond_to do |format|
      if @tour.update(tour_params)
        format.html { redirect_to @tour, notice: 'Truppie atualizada com sucesso' }
        format.json { render :show, status: :ok, location: @tour }
      else
        format.html { redirect_to tours_path, notice: "o campo #{@tour.errors.first[0]} #{@tour.errors.first[1]}" }
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
    
    split_val = ";"
    organizer = params[:tour][:organizer]
    new_organizer = Organizer.find_by_name(organizer)
    
    unless new_organizer.nil?
      new_user = new_organizer.user
      params[:tour][:user] = new_user
    end
    
    params[:tour][:organizer] = new_organizer
    
    if params[:tour][:tags] == "" or params[:tour][:tags].nil?
      params[:tour][:tags] = []
    else
      tags_to_array = params[:tour][:tags].split(split_val)
      tags = []
      tags_to_array.each do |t|
        tags.push Tag.find_or_create_by(name: t)
      end
      params[:tour][:tags] = tags
    end
    
    if params[:tour][:languages] == "" or params[:tour][:languages].nil?
      params[:tour][:languages] = []
    else
      langs_to_array = params[:tour][:languages].split(split_val)
      langs = []
      langs_to_array.each do |l|
        langs.push Language.find_by_name(l)
      end
      params[:tour][:languages] = langs
    end
    
    pkg_attr = params[:tour][:packages_attributes]
    
    if !pkg_attr.nil?
      post_data = [] 
      pkg_attr.each do |p|
        included_array = p[1]["included"].split(split_val)
        post_data.push Package.create(name: p[1]["name"], value: p[1]["value"], included: included_array)
      end
      params[:tour][:packages] = post_data        
    end
    
    if params[:tour][:included] == "" or params[:tour][:included].nil?
      params[:tour][:included] = []
    else
      included_to_array = params[:tour][:included].split(split_val)
      included = []
      included_to_array.each do |i|
        included.push i
      end
      params[:tour][:included] = included
    end
    
    if params[:tour][:nonincluded] == "" or params[:tour][:nonincluded].nil?
      params[:tour][:nonincluded] = []
    else
      nonincluded_to_array = params[:tour][:nonincluded].split(split_val)
      nonincluded = []
      nonincluded_to_array.each do |i|
        nonincluded.push i
      end
      params[:tour][:nonincluded] = nonincluded
    end

    if params[:tour][:take] == "" or params[:tour][:take].nil?
      params[:tour][:take] = []
    else
      take_to_array = params[:tour][:take].split(split_val)
      take = []
      take_to_array.each do |t|
        take.push t
      end
      params[:tour][:take] = take
    end
    
    if params[:tour][:goodtoknow] == "" or params[:tour][:goodtoknow].nil?
      params[:tour][:goodtoknow] = []
    else
      goodtoknow_to_array = params[:tour][:goodtoknow].split(split_val)
      goodtoknow = []
      goodtoknow_to_array.each do |g|
        goodtoknow.push g
      end
      params[:tour][:goodtoknow] = goodtoknow
    end
    
    if params[:tour][:start] == "" or params[:tour][:start].nil?
      params[:tour][:start] = Time.now
    end
    
    if params[:tour][:end] == "" or params[:tour][:end].nil?
      params[:tour][:end] = 4.hours.from_now
    end
    
    current_cat = params[:tour][:category_id]
    
    begin
      if current_cat
        cat = Category.find(current_cat)
        params[:tour][:category] = cat
      end
    rescue ActiveRecord::RecordNotFound => e
      params[:tour][:category] = Category.create(name:current_cat)      
    end
    
    current_where = params[:tour][:where]
    
    begin
      where = Where.find(name:current_where)
    rescue ActiveRecord::RecordNotFound => e
      where = Where.create(name:current_where)
    end
    
    params[:tour][:where] = where
    
    params[:tour][:attractions] = []
    params[:tour][:currency] = "BRL"
    
    params.fetch(:tour, {}).permit(:title, :organizer, :where, :user, :picture, :address, :availability, :minimum, :maximum, :difficulty, :start, :end, :value, :description, :included, :nonincluded, :take, :goodtoknow, :meetingpoint, :category_id, :status, :tags, :languages, :organizer, :user, :attractions, :currency).merge(params[:tour])
  end
end
