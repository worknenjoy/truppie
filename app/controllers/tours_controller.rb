class ToursController < ApplicationController
  before_action :set_tour, only: [:show, :edit, :update, :destroy, :copy_tour]
  before_action :authenticate_user!, :except => [:show]
  before_filter :check_if_admin, only: [:index, :new, :create, :update, :destroy, :copy_tour]
  
  def check_if_admin
    
    allowed_emails = [Rails.application.secrets[:admin_email], Rails.application.secrets[:admin_email_alt]]
    
    unless allowed_emails.include? current_user.email
      flash[:notice] = t('tours_controller_notice_one')
      redirect_to root_url
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
    @tours = Tour.all
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
        format.html { redirect_to @tour, notice: t('tours_controller_create_notice_one') }
        format.json { render :show, status: :created, location: @tour }
      else
        format.html {
          redirect_to guided_tour_organizer_path(tour_params[:organizer] || tour_params[:organizer_id]),
          notice: t('tours_controller_create_notice_two',
          error_one: @tour.errors.first[0], error_two: @tour.errors.first[1])
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
        format.html { redirect_to @tour, notice: t('tours_controller_update_notice') }
        format.json { render :show, status: :ok, location: @tour }
      else
        format.html { redirect_to edit_guided_tour_organizer_path(Organizer.find(tour_params[:organizer_id]), @tour), notice: t('tours_controller_create_notice_two',error_one: @tour.errors.first[0], error_two: @tour.errors.first[1]) }
        format.json { render json: @tour.errors, status: :unprocessable_entity }
      end
    end
  end

  def copy_tour
    organizer = @tour.organizer

    old_tour = @tour
    new_tour = Tour.new(old_tour.attributes.merge({:title => "#{@tour.title} - copiado", :status => '', :id => ''}))

    respond_to do |format|
      if new_tour.save
        format.html {
          redirect_to "/organizers/#{organizer.to_param}/guided_tour", flash: {success: t('tours_controller_copy_success')}
        }
        format.json { render :copy_tour, status: :ok, location: @tour }
      else
        format.html {
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
  
  private
  # Use callbacks to share common setup or constraints between actions.
  def set_tour
    @tour = Tour.find(params[:id])
  end
  
  # Never trust parameters from the scary internet, only allow the white list through.
  def tour_params
    
    split_val = ";"
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
        post_data.push Package.create(name: p[1]["name"], value: p[1]["value"], percent: p[1]["percent"], included: included_array)
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
    
    params.fetch(:tour, {}).permit(:title, :organizer, :where, :user, :picture, :link, :address, :availability, :minimum, :maximum, :difficulty, :start, :end, :value, :description, :included, :nonincluded, :take, :goodtoknow, :meetingpoint, :category_id, :status, :tags, :languages, :organizer, :user, :attractions, :currency).merge(params[:tour])
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

    if params[:final_price].nil? || params[:final_price].empty?
      @final_price = @value
    else
      @final_price = params[:final_price].to_i
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

        if @package
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
            :description => @desc
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
                :payment_method => @payment_method
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

    if params[:final_price].nil? || params[:final_price].empty?
      @final_price = @value
    else
      @final_price = params[:final_price].to_i
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
        payment.credentials = PagSeguro::ApplicationCredentials.new('truppie', 'CDEF210C5C5C6DFEE4E36FBE9DB6F509', @tour.organizer.marketplace.payment_types.first.token)

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

        puts "=> REQUEST"
        puts PagSeguro::PaymentRequest::RequestSerializer.new(payment).to_params

        response = payment.register

        puts
        puts "=> RESPONSE"
        puts response.inspect
        puts response.response.body.inspect
        puts response.url
        puts response.code
        puts response.created_at
        puts response.errors.to_a

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
