class MarketplacesController < ApplicationController
  include ApplicationHelper
  before_action :set_marketplace, only: [:show, :edit, :update, :destroy, :activate, :update_account, :request_external_payment_type_auth]
  before_action :authenticate_user!
  before_filter :check_if_admin, only: [:index, :new, :create, :update, :manage]
  skip_before_action :verify_authenticity_token
  
  def check_if_admin
    allowed_emails = [Rails.application.secrets[:admin_email], Rails.application.secrets[:admin_email_alt]]
    
    unless allowed_emails.include? current_user.email
      flash[:notice] = t('marketplace_controller_notice')
      redirect_to root_path
    end 
  end

  # GET /marketplaces
  # GET /marketplaces.json
  def index
    @marketplaces = Marketplace.all
  end

  # GET /marketplaces/1
  # GET /marketplaces/1.json
  def show
  end

  # GET /marketplaces/new
  def new
    @marketplace = Marketplace.new
  end

  # GET /marketplaces/1/edit
  def edit
  end

  # POST /marketplaces
  # POST /marketplaces.json
  def create
    @marketplace = Marketplace.new(marketplace_params)
    respond_to do |format|
      if @marketplace.save
        format.html {
          redirect_to "/organizers/#{Organizer.find(marketplace_params[:organizer_id]).to_param}/account_status", notice: t('marketplace_controller_notice_two')
        }
        format.json { render :show, status: :created, location: @marketplace }
      else
        format.html { 
          flash[:errors] = @marketplace.errors
          redirect_to :back, notice: t("marketplace-data-incorrect")
        }
        format.json { render json: @marketplace.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /marketplaces/1
  # PATCH/PUT /marketplaces/1.json
  def update
    respond_to do |format|
      if @marketplace.update(marketplace_params)
        format.html { redirect_to @marketplace, notice: t('marketplace_controller_notice_three') }
        format.json { render :show, status: :ok, location: @marketplace }
      else
        format.html { render :edit }
        format.json { render json: @marketplace.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /marketplaces/1
  # DELETE /marketplaces/1.json
  def destroy
    @marketplace.destroy
    respond_to do |format|
      format.html { redirect_to marketplaces_url, notice: t('marketplace_controller_notice_four') }
      format.json { head :no_content }
    end
  end
  
  def activate
    begin
      account = @marketplace.activate
      if account
        if account.id
          @activation_message = t('marketplace_controller_activation_message_one', organizer: @marketplace.organizer.name)
          @activation_status = t('status_success')
          @response = account
          @marketplace.organizer.update_attributes(:market_place_active => true)
          MarketplaceMailer.activate(@marketplace.organizer).deliver_now
        else
          @activation_message = t('marketplace_controller_activation_message_two', organizer: @marketplace.organizer.name)
          @activation_status = t('status_danger')
          @errors = t('marketplace_controller_errors')
        end
      else
        @activation_message = t("marketplace_controller_activation_message_three", organizer: @marketplace.organizer.name)
        @activation_status = t('status_danger')
        @errors = t("marketplace_controller_errors_two")
      end
    rescue => e
        @activation_message = t("marketplace_controller_activation_message_four", organizer: @marketplace.organizer.name)
        @activation_status = t('status_danger')
        @errors = e.message
        puts e.inspect
    end
  end
  
  def update_account
    begin
      account = @marketplace.update_account
      if account
        if account.id
          @activation_message = t("marketplace_controller_activation_message_five", organizer: @marketplace.organizer.name)
          @activation_status = t('status_success')
          @response = account
          MarketplaceMailer.update(@marketplace.organizer).deliver_now
        else
          @activation_message = t("marketplace_controller_activation_message_six", organizer: @marketplace.organizer.name)
          @activation_status = t('status_danger')
          @errors = t('marketplace_controller_errors_three')
        end
      else
        @activation_message = t("marketplace_controller_activation_message_seven", organizer: @marketplace.organizer.name)
        @activation_status = t('status_danger')
        @errors = t("marketplace_controller_errors_four")
      end
    rescue => e
        puts e.inspect
        puts e.backtrace
        @activation_message = t("marketplace_controller_activation_message_eight")
        @activation_status = t('status_danger')
        @errors = e.message
    end
  end

  def request_external_payment_type_auth
    if @marketplace.payment_types.any?
      @authorize = @marketplace.payment_types_authorize
      if @authorize
        if @marketplace.payment_types.first.email && @marketplace.payment_types.first.auth
          @activation_status = "success"
          @activation_message = "Autorização enviada para o cliente com sucesso"
          MarketplaceMailer.request_app_auth(@marketplace).deliver_now
        end
      else
        @activation_status = "danger"
        @activation_message = "Não foi possível tentar autorizar esta conta"
      end
    else
      @activation_status = "danger"
      @activation_message = "Não foi ativada nenhuma forma de pagamento externa associada"
    end
  end

  def redirect
    @notificationCode = params["notificationCode"]
    @pubkey = params["publicKey"]
    if @notificationCode
      response = RestClient.get "https://ws.pagseguro.uol.com.br/v2/authorizations/notifications/#{@notificationCode}?appId=truppie&appKey=CDEF210C5C5C6DFEE4E36FBE9DB6F509"
      xml_to_json_response = Hash.from_xml(response.body).to_json
      puts xml_to_json_response.inspect
      response_json = JSON.parse(xml_to_json_response)
      @payment_type_id = response_json["authorization"]["reference"]
      @email = response_json["authorization"]["authorizerEmail"]
      begin
        @payment_type = PaymentType.find(@payment_type_id)
      rescue ActiveRecord::RecordNotFound
        @payment_type = PaymentType.where(email: @email ).first
      end
      @code = response_json["authorization"]["code"]
      @payment_update = @payment_type.update_attributes({:token => @code})
      if @payment_update
        @activation_status = "success"
        @activation_message = "Sua forma de pagamento pelo #{@payment_type.type_name} foi autorizada com sucesso, agora suas truppies irão oferecer esta nova forma automaticamente"
      else
        @activation_status = "danger"
        @activation_message = "Não foi possvel autorizar o #{@payment_type.type_name} como forma de pagamento. Não encontramos o código enviado pelo serviço"
      end
      ContactMailer.notify("foi enviada uma notificacao <strong>#{@notificationCode}</strong> de autorizacao do pagseguro e consultando obteve <code>#{response.body.inspect}</code> como resposta e pub key #{@pubkey}").deliver_now
    end
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_marketplace
      @marketplace = Marketplace.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def marketplace_params
      params.fetch(:marketplace, {}).permit(:organizer_id, :photo, :active, :person_name, :person_lastname, :document_type, :id_number, :id_type, :id_issuer, :id_issuerdate, :birthDate, :street, :street_number, :complement, :district, :zipcode, :city, :state, :country, :token, :account_id, :document_number, :business, :company_street, :compcompany_complement, :company_zipcode, :company_city, :company_state, :company_country, bank_accounts_attributes: [:bank_number, :agency_number, :agency_check_number, :account_number, :account_check_number, :doc_number, :doc_type, :bank_type, :fullname, :active, :marketplace_id]).merge(params[:marketplace])
    end
end
