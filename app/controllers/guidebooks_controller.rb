class GuidebooksController < ApplicationController
  before_action :set_guidebook, only: [:show, :edit, :update, :destroy]

  before_action :authenticate_user!, :except => [:show, :index]
  before_filter :check_if_organizer_admin, only: [:create, :update, :destroy]

  # GET /guidebooks
  # GET /guidebooks.json
  def index
    @guidebooks = Guidebook.all
  end

  # GET /guidebooks/1
  # GET /guidebooks/1.json
  def show
  end

  # GET /guidebooks/new
  def new
    @guidebook = Guidebook.new
  end

  # GET /guidebooks/1/edit
  def edit
  end

  # POST /guidebooks
  # POST /guidebooks.json
  def create
    @guidebook = Guidebook.new(guidebook_params)

    respond_to do |format|
      if @guidebook.save
        format.html { redirect_to @guidebook, notice: 'Guidebook was successfully created.' }
        format.json { render :show, status: :created, location: @guidebook }
      else
        format.html { render :new }
        format.json { render json: @guidebook.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /guidebooks/1
  # PATCH/PUT /guidebooks/1.json
  def update
    respond_to do |format|
      if @guidebook.update(guidebook_params)
        format.html { redirect_to @guidebook, notice: 'Guidebook was successfully updated.' }
        format.json { render :show, status: :ok, location: @guidebook }
      else
        format.html {
          puts @guidebook.errors.inspect
          render :edit
        }
        format.json { render json: @guidebook.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /guidebooks/1
  # DELETE /guidebooks/1.json
  def destroy
    @guidebook.destroy
    respond_to do |format|
      format.html { redirect_to guidebooks_url, notice: 'Guidebook was successfully destroyed.' }
      format.json { head :no_content }
    end
  end


  def confirm
    @guidebook = Guidebook.find(params[:id])
    @packagename = params[:packagename]

    if @guidebook.value
      @final_price = @guidebook.value
    else
      if params[:package]
        @package = @guidebook.packages.find(params[:package])
        @final_price = @package.value
      elsif @packagename
        @package = @guidebook.packages.find_by_name(@packagename)
        @final_price = @package.value
      else
        @final_price = ""
      end
    end
  end

  def confirm_presence
    @guidebook = Guidebook.find(params[:id])
    @value = params[:value].to_i
    if params[:package]
      @package = @guidebook.packages.find(params[:package])
    elsif params[:packagename]
      @package = @guidebook.packages.find_by_name(params[:packagename])
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


    if @tour.try(:description)
      @desc = @guidebook.try(:description).first(250)
    else
      @desc = t('tours_controller_desc',title: @guidebook.title, organizer: @guidebook.organizer.name)
    end

    @organizer_percent = @guidebook.organizer.percent || 1
    @guidebook_total_percent = 0.95 - (@organizer_percent/100.00)

    @price_cents = (@final_price*100).to_i

    @liquid = (@price_cents)*(@guidebook_total_percent)

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
            :type => 'guidebook',
            :object_id => @guidebook.id
        }
    }

    if @guidebook.organizer.try(:marketplace)
      if @guidebook.organizer.marketplace.try(:account_id)
        @account_id = @guidebook.organizer.marketplace.account_id
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
        @order = @guidebook.orders.create(
            :source_id => @payment[:source][:id],
            :own_id => "truppie_#{@guidebook.id}_#{current_user.id}",
            :user => current_user,
            :guidebook => @guidebook,
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
          @guidebook.save()
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

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_guidebook
      @guidebook = Guidebook.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def guidebook_params

      split_val = ";"
      organizer = params[:guidebook][:organizer_id] || params[:guidebook][:organizer]


      if organizer.class == String
        new_organizer = Organizer.find_by_name(organizer)

        unless new_organizer.nil?
          new_user = new_organizer.user
          params[:guidebook][:user] = new_user
          params[:guidebook][:organizer] = new_organizer
        end
      end

      if params[:guidebook][:tags] == "" or params[:guidebook][:tags].nil?
        params[:guidebook][:tags] = []
      else
        tags_to_array = params[:guidebook][:tags].split(split_val)
        tags = []
        tags_to_array.each do |t|
          tags.push Tag.find_or_create_by(name: t)
        end
        params[:guidebook][:tags] = tags
      end

      if params[:guidebook][:languages] == "" or params[:guidebook][:languages].nil?
        params[:guidebook][:languages] = []
      else
        langs_to_array = params[:guidebook][:languages].split(split_val)
        langs = []
        langs_to_array.each do |l|
          langs.push Language.find_or_create_by(name: l)
        end
        params[:guidebook][:languages] = langs
      end

      pkg_attr = params[:guidebook][:packages]

      if !pkg_attr.nil?
        post_data = []
        pkg_attr.each do |p|
          included_array = p[1]["included"].split(split_val)
          post_data.push Package.create(name: p[1]["name"], value: p[1]["value"], percent: p[1]["percent"], description: p[1]["description"], included: included_array)
        end
        params[:guidebook][:packages] = post_data
      end

      if params[:guidebook][:included] == "" or params[:guidebook][:included].nil?
        params[:guidebook][:included] = []
      else
        included_to_array = params[:guidebook][:included].split(split_val)
        included = []
        included_to_array.each do |i|
          included.push i
        end
        params[:guidebook][:included] = included
      end

      if params[:guidebook][:nonincluded] == "" or params[:guidebook][:nonincluded].nil?
        params[:guidebook][:nonincluded] = []
      else
        nonincluded_to_array = params[:guidebook][:nonincluded].split(split_val)
        nonincluded = []
        nonincluded_to_array.each do |i|
          nonincluded.push i
        end
        params[:guidebook][:nonincluded] = nonincluded
      end

      current_category = params[:guidebook][:category]

      if current_category == "" or current_category.nil?
        params[:guidebook][:category] = Category.find_or_create_by(name: 'Outras')
      else
        begin
          params[:guidebook][:category] = Category.find(current_category)
        rescue => e
          params[:guidebook][:category] = Category.find_or_create_by(name: current_category)
        end
      end

      params[:guidebook][:currency] = "BRL"

      # unpermitted params error even with all params provided
      #params.require(:guidebook).permit(:title, :currency, :picture, :organizer_id, :file, :value, :description, :status, :category_id, user: [:id, :name], organizer: [:id, :name], tags: [:id, :name], languages: [:id, :name], category: [:id, :name], packages_attributes: [:id, :name, :value, :description, :percent, :included], wheres_attributes: [:id, :name, :place_id, :background_id, :lat, :long, :city, :state, :country, :postal_code, :address, :google_id, :url], included: [], nonincluded: []).merge(params[:guidebook])
      params.require(:guidebook).permit!
    end
end
