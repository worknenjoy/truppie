class ToursController < ApplicationController
  before_action :set_tour, only: [:show, :edit, :update, :destroy, :copy_tour]

  before_action :authenticate_user!, :except => [:show, :products, :product, :product_availability]
  before_filter :check_if_super_admin, only: [:new, :edit, :index]
  before_filter :check_if_organizer_admin, only: [:create, :update, :destroy, :copy_tour]

  skip_before_action :authenticate_user!, if: :json_request?
  skip_before_action :check_if_super_admin, if: :json_request?, only: [:index]

  before_filter :scoped_index, only: [:index]

  def scoped_index
    allowed_emails = [Rails.application.secrets[:admin_email], Rails.application.secrets[:admin_email_alt]]
    if current_user
      @tours = allowed_emails.include?(current_user.email) ? Tour.all : Tour.publisheds
    else
      @tours = Tour.publisheds
    end
  end

  def confirm
    @tour = Tour.find(params[:id])
    @packagename = params[:packagename]

    if @tour.value
      @final_price = @tour.value
    else
      if params[:package]
        @package = @tour.packages.find(params[:package])
        @final_price = @package.value
      elsif @packagename
        @package = @tour.packages.find_by_name(@packagename)
        @final_price = @package.value
      else
        @final_price = ""
      end
    end
    @marketplace = @tour.organizer.try(:marketplace)
    if @marketplace
      @external_payment_active = true if @marketplace.payment_types.any?
      if @external_payment_active
        @payment_type = 'external' if @marketplace.payment_types.first.email
      end
    end

  end

  def products
    @products = RestClient.get "https://api.rezdy.com/latest/products/marketplace?language=en&limit=5&automatedPayments=true&apiKey=#{Rails.application.secrets[:rezdy_api]}"
    @products_json = JSON.load @products
  end

  def product
    @id = params[:id]
    @product = RestClient.get "https://api.rezdy.com/latest/products/#{@id}/?apiKey=#{Rails.application.secrets[:rezdy_api]}"
    @product_json = JSON.load @product
    puts @product_json
    @tour = Tour.last
  end

  def product_availability
    @code = params[:code]
    @availability = RestClient.get "https://api.rezdy.com/latest/availability/?productCode=#{@code}&startTime=2018-03-09T00:00:00Z&endTime=2019-03-01T00:00:00Z&apiKey=#{Rails.application.secrets[:rezdy_api]}"
    @availability_json = JSON.load @availability
    render json: @availability_json
  end

  def confirm_product
    @product_id = params[:id]
    @product_name = params[:name]
    @product_prices = params[:prices]
    @product_starts = params[:starts]
    @product_labels = params[:labels]
    @product_total_price = @product_prices.map(&:to_i).reduce(0, :+)
    @product_reservations = params[:products]
  end

  def confirm_product_booking
    @product_id = params[:id]
    @product_reservations = params[:products]
    @product_name = params[:product_name]
    @product_total_price = params[:product_total_price]
    @product_prices = params[:product_prices]
    @product_starts = params[:product_starts]
    @token = params[:token]

    @booking_post_params = {
        customer: {
            firstName: params[:firstName],
            lastName: params[:lastName],
            email: current_user.email,
            phone: ""
        },
        items: [
            {
                productCode: @product_id,
                startTimeLocal: @product_starts[0],
                amount: @product_prices[0],
                quantities: [
                    {
                        optionLabel: "Adult",
                        value: 1
                    }
                ],
                participants: [
                    fields: [
                        {
                            label: "First Name",
                            value: params[:firstName]
                        },
                        {
                            label: "Last Name",
                            value: params[:lastName]
                        }
                    ]
                ]
            }
        ],
        creditCard: {
            cardToken: @token
        }
    }

    begin
      @book_product = RestClient.post "https://api.rezdy.com/latest/bookings/?apiKey=#{Rails.application.secrets[:rezdy_api]}", @booking_post_params.to_json, :content_type => :json, :accept => :json
    rescue => e
      puts "error when request rezdy api"
      puts e.inspect
      @book_product = "{}"
    end
    @book_product_json = JSON.load @book_product
    puts "product_json"
    puts @book_product_json.inspect


    if @book_product_json["requestStatus"] and @book_product_json["requestStatus"]["success"]

      @order_number = @book_product_json["booking"]["orderNumber"]

      begin
        @order = Order.create(
          :source_id => @product_id,
          :own_id => "truppie_product_#{@product_id}_#{current_user.id}_#{@order_number}",
          :user => current_user,
          :status => 'succeeded',
          :payment => @order_number,
          :price => 0,
          :amount => 0,
          :final_price => 0,
          :liquid => 0,
          :fee => 0,
          :payment_method => @payment_method,
        )
        @confirm_headline_message = t('tours_controller_confirm_headline_msg')
        @confirm_status_message = t('tours_controller_status_msg_four')
        @status = t('status_success')
      rescue => e
        @confirm_headline_message = t('tours_controller_headline_msg')
        @confirm_status_message = e.message
        @status = t('status_danger')
      end
    else
      @confirm_headline_message = t('tours_controller_headline_msg')
      @confirm_status_message = "Não foi possível confirmar sua reserva com o agente de viagens"
      @status = t('status_danger')
    end

  end

  def show_interest
    respond_to do |format|
      @tour = Tour.find(params[:id])

      unless !!@tour
        flash[:error] = t('tours_controller_interest_error')
      else
        if OrganizerMailer.interest(@tour, current_user).deliver_now
          flash[:notice] = t('tours_controller_interest_succes')
        else
          flash[:error] = t('tours_controller_interest_error')
        end
      end

      format.html { redirect_to url_for(:tour) }
      format.js
    end
  end

  def confirm_presence
    @payment_type = params[:payment_type]
    if @payment_type == 'external'
      confirm_external(params)
    else
      confirm_direct(params)
    end
  end

  def confirm_presence_alt
    @confirm_headline_message = t('tours_controller_confirm_headline_msg_two')
    @confirm_status_message = t('tours_controller_confirm_status_msg')
    @status = t('status_success')
    @tour = Tour.last
    @order = current_user.orders.last
    @amount = 2
    @final_price = 80
    @payment_method = "CREDIT_CARD"
    render 'confirm_presence'
  end

  def unconfirm_presence
    @tour = Tour.find(params[:id])
    @order = current_user.orders.where(:tour => @tour).first
    reserveds = @tour.reserved
    if @tour.confirmeds.where(user: current_user).delete_all
      @tour.update_attributes(:reserved => reserveds - @order.amount)
      flash[:success] = t('tours_controller_unconfirm_success')
    else
      flash[:error] = t('tours_controller_unconfirm_error')
    end
    redirect_to @tour
  end

  # GET /tours
  # GET /tours.json
  def index

  end

  # GET /tours/1
  # GET /tours/1.json
  def show
    @pictures = TourPicture.where(:tour => @tour.id)
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
        OrganizerMailer.notify_followers(@tour).deliver_now if (@tour.status == "P")
        format.html { redirect_to @tour, notice: t('tours_controller_create_notice_one') }
        format.json { render :show, status: :created, location: @tour }
      else
        format.html {
          flash[:errors] = @tour.errors
          flash[:opened] = true
          redirect_to guided_tour_organizer_path(tour_params[:organizer] || tour_params[:organizer_id]),
                      notice: t('tours_controller_create_notice_two')
        }
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
        OrganizerMailer.notify_followers(@tour).deliver_now if (@tour.status == "P")
        format.html { redirect_to @tour, notice: t('tours_controller_update_notice') }
        format.json { render :show, status: :ok, location: @tour }
      else
        format.html {
          puts @tour.errors.inspect
          flash[:errors] = @tour.errors
          redirect_to :back,
                      notice: t('tours_controller_create_notice_two')
        }
        format.json { render json: @tour.errors, status: :unprocessable_entity }
      end
    end
  end

  def copy_tour
    organizer = @tour.organizer

    old_wheres = @tour.wheres
    old_packages = @tour.packages
    old_tour = @tour

    new_tour = Tour.new(old_tour.attributes.merge({:title => "#{@tour.title} - copiado", :status => '', :id => ''}))

    new_tour.wheres << old_wheres

    if old_packages.present?
      new_tour.packages << old_packages
    end

    respond_to do |format|
      if new_tour.save
        format.html {
          redirect_to "/organizers/#{organizer.to_param}/guided_tour", flash: {notice: t('tours_controller_copy_success')}
        }
        format.json { render :copy_tour, status: :ok, location: @tour }
      else
        format.html {
          puts 'copy tour error'
          puts new_tour.errors.inspect
          redirect_to "/organizers/#{organizer.to_param}/guided_tour", flash: {notice: t('tours_controller_copy_error')}
        }
        format.json { render json: @tour.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tours/1
  # DELETE /tours/1.json
  def destroy
    if @tour.update_attributes({:removed => true})
      respond_to do |format|
        format.html { redirect_to "/organizers/#{@tour.organizer.to_param}/guided_tour", flash: {success: t('tours_controller_destroy_notice')} }
        format.json { head :no_content }
      end
    else
      format.html { redirect_to "/organizers/#{@tour.organizer.to_param}/guided_tour", flash: {error: t('tours_controller_destroy_notice_fail')} }
      format.json { head :no_content }
    end
  end

  protected
  def json_request?
    request.format.json?
  end

  def check_if_admin

    allowed_emails = [Rails.application.secrets[:admin_email], Rails.application.secrets[:admin_email_alt]]

    unless allowed_emails.include? current_user.email
      flash[:notice] = t('tours_controller_notice_one')
      redirect_to root_url
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_tour
    @tour = Tour.includes(:wheres).find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def tour_params

    split_val = /[,;.]+/
    organizer = params[:tour][:organizer_id] || params[:tour][:organizer]


    if organizer.class == String
      new_organizer = Organizer.find_by_name(organizer)

      unless new_organizer.nil?
        new_user = new_organizer.user
        params[:tour][:user] = new_user
        params[:tour][:organizer] = new_organizer
      end
    end

    if params[:tour][:tags] == "" or params[:tour][:tags].nil?
      params[:tour][:tag_ids] = []
    else
      params[:tour][:tag_ids] = params[:tour][:tags]
        .split(split_val)
        .map{|t| Tag.find_or_create_by(name: t).try(:id) }.compact
    end
    params[:tour].delete(:tags)

    if params[:tour][:languages] == "" or params[:tour][:languages].nil?
      params[:tour][:languages] = []
    else
      params[:tour][:language_ids] = params[:tour][:languages]
        .split(split_val)
        .map{|l| Language.find_or_create_by(name: l).try(:id) }.compact
    end
    params[:tour].delete(:languages)

    pkg_attr = params[:tour][:packages_attributes]

    if !pkg_attr.nil?
      pkg_attr.each do |p|
        included_array = p[1]["included"].split(split_val) rescue nil
        if included_array
          params[:tour][:packages_attributes][p[0]][:included] = included_array
        else
          params[:tour][:packages_attributes][p[0]][:included] = []
        end
      end
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

    #current_where = params[:tour][:wheres_attributes][0]

    #if current_where
    #  where_exist = Where.where({place_id: current_where["0"][:place_id] })
    #else
    #  where_exist = {}
    #end

    #if where_exist.any?
    #  params[:tour][:wheres_attributes] = where_exist[0]
    #end

    current_category = params[:tour][:category]

    if current_category == "" or current_category.nil?
      params[:tour][:category] = Category.find_or_create_by(name: 'Outras')
    else
      begin
        params[:tour][:category] = Category.find(current_category)
      rescue => e
        params[:tour][:category] = Category.find_or_create_by(name: current_category)
      end
    end

    params[:tour][:attractions] = []
    params[:tour][:currency] = "BRL"

    #params.fetch(:tour, {}).permit(:title, :organizer_id, :status, {:packages => [:name, :value, :included]}, {:packages_attributes => [:name, :value, :included]}, {:where_attributes => [:name, :place_id, :background_id, :lat, :long, :city, :state, :country, :postal_code, :address, :google_id, :url]}, :user_id, :picture, :link, :address, :availability, :minimum, :maximum, :difficulty, :start, :end, :value, :description, {:included => []}, {:nonincluded => []}, {:take => []}, {:goodtoknow => []}, :meetingpoint, :category_id, :category, :tags, {:languages => []}, :organizer, :user, {:attractions => []}, :currency).merge(params[:tour])
    params.fetch(:tour, {}).permit!
  end

  def confirm_direct(params)
    @tour = Tour.find(params[:id])
    @value = params[:value].to_i
    if params[:package]
      @package = @tour.packages.find(params[:package])
    elsif params[:packagename]
      @package = @tour.packages.find_by_name(params[:packagename])
    else
      @package = nil
    end

    @payment_method = params[:method]

    if params[:amount].nil? || params[:amount].empty?
      @amount = 1
    else
      @amount = params[:amount].to_i
    end

    @services = []
    if params[:tour].try(:services_attributes)
      params[:tour][:services_attributes].each do |k, v|      
        if v[:value]        
          @services << Service.find(v[:id])
        end
      end
      
      @sum_services = @services.reduce(0) do |sum, s| 
        sum + s.value
      end    
      @value += @sum_services
    end

    if @value && params[:value_chosen_by_user]
      @final_price = @amount * @value
    else
      @final_price = params[:final_price].try(:to_i) || @value
    end

    begin
      valid_birthdate = params[:birthdate].to_date
    rescue => e
      puts e.inspect
      @confirm_headline_message = t("tours_controller_headline_msg")
      @confirm_status_message = t("tours_controller_status_msg")
      @status = t('status_danger')
      return
    end

    if @tour.confirmeds.exists?(user: current_user)
      flash[:error] = t('tours_controller_errors_one')
      redirect_to @tour
    else
      if !@tour.soldout?
        if @tour.try(:description)
          @desc = @tour.try(:description).first(250)
        else
          @desc = t('tours_controller_desc',title: @tour.title, organizer: @tour.organizer.name)
        end

        @organizer_percent = @tour.organizer.percent || 1
        @tour_total_percent = 0.95 - (@organizer_percent/100.00)

        if @tour.collaborators.any?
          @tour_collaborator_percent = (@tour.collaborators.first.percent || 0) / 100.00
        else
          @tour_collaborator_percent = 0
        end
        
        if @package.try(:percent)
          @tour_package_percent = @package.percent
          @tour_package_percent_factor = @tour_package_percent / 100.00
        else
          @tour_package_percent = 0
          @tour_package_percent_factor = 0
        end

        @price_cents = (@final_price*100).to_i

        @liquid = (@price_cents)*(@tour_total_percent - @tour_collaborator_percent - @tour_package_percent_factor)

        @fees = {
            :fee => (@price_cents - @liquid).round.to_i,
            :liquid => @liquid.round.to_i,
            :total => @price_cents
        }

        @new_charge = {
            :currency => "brl",
            :amount => @fees[:total],
            :source => params[:token],
            :description => @desc,
            :metadata => {
                :type => 'tour',
                :object_id =>  @tour.id
            }
        }

        if @tour.organizer.try(:marketplace)
          if @tour.organizer.marketplace.try(:account_id)
            @account_id = @tour.organizer.marketplace.account_id
            @new_charge.store(:destination, {
                :account => @account_id,
                :amount => @fees[:liquid]
            })
          end
        end

        begin
          @payment = Stripe::Charge.create(@new_charge)
            #puts payment.inspect
        rescue Stripe::CardError => e
          puts e.inspect
          #puts e.backtrace
          ContactMailer.notify(t('tours_controller_mailer_notify_one', name: current_user.name, email: current_user.email, inspect: e.inspect)).deliver_now
          @confirm_headline_message = t('tours_controller_headline_msg')
          @confirm_status_message = t('tours_controller_status_msg_two')
          @status = t('status_danger')
          return
        rescue => e
          puts e.inspect
          #puts e.backtrace
          ContactMailer.notify(t('tours_controller_mailer_notify_one', name: current_user.name, email: current_user.email, inspect: e.inspect)).deliver_now
          @confirm_headline_message = t('tours_controller_headline_msg')
          @confirm_status_message = t('tours_controller_status_msg_three')
          @status = t('status_danger')
          return
        end

        if @payment.try(:status)

          if @payment.try(:id)
            @tour.confirmeds.new(:user  => current_user)
            amount_reserved_now = @tour.reserved
            @reserved_increment = amount_reserved_now + @amount
            @tour.update_attributes(:reserved => @reserved_increment)

            @order = @tour.orders.create(
                :source_id => @payment[:source][:id],
                :own_id => "truppie_#{@tour.id}_#{current_user.id}",
                :user => current_user,
                :tour => @tour,
                :status => @payment[:status],
                :payment => @payment[:id],
                :price => @value.to_i*100,
                :amount => @amount,
                :final_price => @price_cents,
                :liquid => @fees[:liquid],
                :fee => @fees[:fee],
                :payment_method => @payment_method,
                :package => @package,
                :services => @services
            )

            begin
              @tour.save()
              @confirm_headline_message = t('tours_controller_confirm_headline_msg')
              @confirm_status_message = t('tours_controller_status_msg_four')
              @status = t('status_success')
            rescue => e
              puts e.inspect
              @confirm_headline_message = t('tours_controller_headline_msg')
              @confirm_status_message = e.message
              @status = t('status_danger')
            end
          else
            @confirm_headline_message = t('tours_controller_headline_msg')
            @confirm_status_message = t('tours_controller_status_msg_five')
            @status = t('status_danger')
            ContactMailer.notify( t(tours_controller_mailer_notify_two , name: current_user.name, email: current_user.email, inspect: @payment.inspect)).deliver_now
          end
        else
          @confirm_headline_message = t('tours_controller_headline_msg')
          @confirm_status_message = t('tours_controller_status_msg_six')
          @status = t('status_danger')
          ContactMailer.notify(t('tours_controller_mailer_notify_three', name: current_user.name, email: current_user.email )).deliver_now
        end
      else
        @confirm_headline_message = t('tours_controller_headline_msg')
        @confirm_status_message = t('tours_controller_status_msg_seven')
        @status = t('status_danger')
        redirect_to @tour
      end
    end
  end

  def confirm_external(params)
    @tour = Tour.find(params[:id])

    @value = params[:value].to_i
    if params[:package]
      @package = @tour.packages.find(params[:package])
    elsif params[:packagename]
      @package = @tour.packages.find_by_name(params[:packagename])
    else
      @package = nil
    end

    @payment_method = params[:method]

    if params[:amount].nil? || params[:amount].empty?
      @amount = 1
    else
      @amount = params[:amount].to_i
    end

    if @value && params[:value_chosen_by_user]
      @final_price = @amount * @value
    else
      @final_price = params[:final_price].try(:to_i) || @value
    end

    @price_cents = (@final_price*100).to_i

    @fees = {
        :fee => (@price_cents).round.to_i,
        :liquid => @price_cents.to_i,
        :total => @price_cents
    }

    if @tour.confirmeds.exists?(user: current_user)
      flash[:error] = t('tours_controller_errors_one')
      redirect_to @tour
    else
      if !@tour.soldout?

        @own_id = "truppie_#{@tour.id}"

        payment = PagSeguro::PaymentRequest.new
        payment.credentials = PagSeguro::ApplicationCredentials.new('truppie', Rails.application.secrets[:pagseguro_secret], @tour.organizer.marketplace.payment_types.first.token)

        payment.reference = @own_id
        payment.notification_url = "http://www.truppie.com/webhook_external_payment"
        payment.redirect_url = "http://www.truppie.com/redirect_external"

        #payment.extra_params << { senderBirthDate: valid_birthdate }

        payment.items << {
            id: @own_id,
            description: @tour.title,
            amount: @value.to_i,
            quantity: @amount
        }


        response = payment.register

        if response.url
          if response.errors.any?
            puts response.inspect
            @confirm_headline_message = "Não foi possível confirmar sua reserva"
            @confirm_status_message = "Tivemos um problema para acessar o sistema"
            @status = "danger"
          else
            @order = @tour.orders.create(
                :source => @tour.organizer.marketplace.payment_types.first.type_name,
                # :source_id => @payment[:source][:id],
                :own_id => @own_id,
                :user => current_user,
                :tour => @tour,
                :status => 'pending',
                # :payment => @payment[:id],
                :price => @value.to_i*100,
                :amount => @amount,
                :final_price => @price_cents,
                :liquid => @fees[:liquid],
                :fee => @fees[:fee],
                :payment_method => @payment_method
            )
            @order.update_attributes({:payment => response.url, :source_id => response.code })
            redirect_to response.url
          end
        else
          @confirm_headline_message = "Não foi possível confirmar sua reserva"
          @confirm_status_message = "Tivemos um problema para acessar o sistema"
          @status = "danger"
        end
      else
        @confirm_headline_message = "Não foi possível confirmar sua reserva"
        @confirm_status_message = "Este evento está esgotado"
        @status = "danger"
      end
    end
  end
end
