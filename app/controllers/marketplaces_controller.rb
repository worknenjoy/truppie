class MarketplacesController < ApplicationController
  include ApplicationHelper
  before_action :set_marketplace, only: [:show, :edit, :update, :destroy, :activate, :update_account]
  before_action :authenticate_user!
  before_filter :check_if_admin, only: [:index, :new, :create, :update, :manage]
  
  def check_if_admin
    allowed_emails = ["laurinha.sette@gmail.com", "alexanmtz@gmail.com"]
    
    unless allowed_emails.include? current_user.email
      flash[:notice] = "Você não está autorizado a entrar nesta página"
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
          redirect_to @marketplace, notice: 'Marketplace was successfully created.' 
        }
        format.json { render :show, status: :created, location: @marketplace }
      else
        format.html { 
          @errors = @marketplace.errors
          render :new, notice: "#{@marketplace.errors.inspect}" 
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
        format.html { redirect_to @marketplace, notice: 'Marketplace was successfully updated.' }
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
      format.html { redirect_to marketplaces_url, notice: 'Marketplace was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  def activate
    begin
      account = @marketplace.activate
      if account
        if account.id
          @activation_message = "Conseguimos com sucesso criar uma conta no marketplace para #{@marketplace.organizer.name}"
          @activation_status = "success"
          @response = account
          @marketplace.organizer.update_attributes(:market_place_active => true)
          MarketplaceMailer.activate(@marketplace.organizer).deliver_now
        else
          @activation_message = "Marketplace #{@marketplace.organizer.name} não foi criado"
          @activation_status = "danger"
          @errors = "Houve algum problema e ele não gerou o id"
        end
      else
        @activation_message = "Marketplace #{@marketplace.organizer.name} já se encontra ativo"
        @activation_status = "danger"
        @errors = "Já se encontra ativo"
      end
    rescue => e
        @activation_message = "Marketplace #{@marketplace.organizer.name} não pôde ser ativado devido a problema na API do Stripe"
        @activation_status = "danger"
        @errors = e.message
    end
  end
  
  def update_account
    begin
      account = @marketplace.update_account
      if account
        if account.id
          @activation_message = "Conseguimos com sucesso atualizar sua conta do #{@marketplace.organizer.name}"
          @activation_status = "success"
          @response = account
          MarketplaceMailer.update(@marketplace.organizer).deliver_now
        else
          @activation_message = "Marketplace #{@marketplace.organizer.name} não foi atualizado"
          @activation_status = "danger"
          @errors = "Houve algum problema e ele não achou sua conta"
        end
      else
        @activation_message = "Marketplace #{@marketplace.organizer.name} já se encontra ativo"
        @activation_status = "danger"
        @errors = "Já se encontra ativo"
      end
    rescue => e
        @activation_message = "O Marketplace não pôde ser atualizado devido a problema na API do Stripe"
        @activation_status = "danger"
        @errors = e.message
    end
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_marketplace
      @marketplace = Marketplace.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def marketplace_params
      params.fetch(:marketplace, {}).permit(:organizer_id, :active, :person_name, :person_lastname, :document_type, :id_number, :id_type, :id_issuer, :id_issuerdate, :birthDate, :street, :street_number, :complement, :district, :zipcode, :city, :state, :country, :token, :account_id, :document_number, :business, :company_street, :compcompany_complement, :company_zipcode, :company_city, :company_state, :company_country, bank_accounts_attributes: [:bank_number, :agency_number, :agency_check_number, :account_number, :account_check_number, :doc_number, :doc_type, :bank_type, :fullname, :active, :marketplace_id]).merge(params[:marketplace])
    end
end
