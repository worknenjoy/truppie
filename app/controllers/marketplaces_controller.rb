class MarketplacesController < ApplicationController
  before_action :set_marketplace, only: [:show, :edit, :update, :destroy, :activate]
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
        format.html { redirect_to @marketplace, notice: 'Marketplace was successfully created.' }
        format.json { render :show, status: :created, location: @marketplace }
      else
        format.html { render :new }
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
    account_bank_data = @marketplace.account_info
    response = RestClient.post("#{Rails.application.secrets[:moip_domain]}/accounts", account_bank_data.to_json, :content_type => :json, :accept => :json, :authorization => Rails.application.secrets[:moip_app_token]){|response, request, result, &block| 
        case response.code
          when 400 
            @activation_message = "Não foi possível ativar o marketplace para #{@marketplace.organizer.name}, verifique os dados novamente."
            @activation_status = "danger"
            @errors = JSON.parse response
          when 201
            @activation_message = "Conseguimos com sucesso criar uma conta no marketplace para #{@marketplace.organizer.name}"
            @activation_status = "success"
            @response = JSON.parse response
            @marketplace.update_attributes(
              :active => true,
              :account_id => @response["id"],
              :token => @response["accessToken"]
            )
          else
            @activation_message = "Não conseguimos resposta do Moip para ativar #{@marketplace.organizer.name}, verifique os dados novamente."
            @activation_status = "danger"
          end
    }
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_marketplace
      @marketplace = Marketplace.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def marketplace_params
      
      
      
      params.fetch(:marketplace, {}).permit(:organizer_id, :bank_accounts, :active, :person_name, :person_lastname, :document_type, :id_number, :id_type, :id_issuer, :id_issuerdate, :birthDate, :street, :street_number, :complement, :district, :zipcode, :city, :state, :country, :token, :account_id).merge(params[:marketplace])
    end
end
