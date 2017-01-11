class BankAccountsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_bank_account, only: [:show, :edit, :update, :destroy, :activate]
  
  
  def activate
    if !@bank_account.own_id.nil?
      @activation_message = "Esta conta bancária do #{@bank_account.marketplace.organizer.name} já foi ativada"
      @activation_status = "danger"
      @errors = { :errors => { :description => "já tem uma conta no moip associada a esta conta"} }
    else
      bank_account_data = @bank_account.marketplace.bank_account
      response = RestClient.post("#{Rails.application.secrets[:moip_domain]}/accounts/#{@bank_account.marketplace.account_id}/bankaccounts", bank_account_data.to_json, :content_type => :json, :accept => :json, :authorization => "OAuth #{@bank_account.marketplace.token}"){|response, request, result, &block| 
          #puts @bank_account.marketplace.account_id
          #puts "OAuth #{@bank_account.marketplace.token}"
          #puts response.inspect
          #puts response.code
          case response.code
            when 400 
              @activation_message = "Não foi possível ativar o marketplace para #{@bank_account.marketplace.organizer.name}, verifique os dados novamente."
              @activation_status = "danger"
              @errors = JSON.parse response
            when 401
              @activation_message = "Não foi possível ativar o marketplace para #{@bank_account.marketplace.organizer.name} devido a erro na autenticação"
              @activation_status = "danger"
              @errors = JSON.parse response
            when 201
              @activation_message = "Conseguimos com sucesso criar uma conta no marketplace para #{@bank_account.marketplace.organizer.name}"
              @activation_status = "success"
              @response = JSON.parse response
              @bank_account.update_attributes(:own_id => @response["id"])
            else
              @activation_message = "Não conseguimos resposta do Moip para ativar #{@bank_account.marketplace.organizer.name}, verifique os dados novamente."
              @activation_status = "danger"
            end
        }
      end
  end

  # GET /bank_accounts
  # GET /bank_accounts.json
  def index
    @bank_accounts = BankAccount.all
  end

  # GET /bank_accounts/1
  # GET /bank_accounts/1.json
  def show
  end

  # GET /bank_accounts/new
  def new
    @bank_account = BankAccount.new
  end

  # GET /bank_accounts/1/edit
  def edit
  end

  # POST /bank_accounts
  # POST /bank_accounts.json
  def create
    @bank_account = BankAccount.new(bank_account_params)

    respond_to do |format|
      if @bank_account.save
        format.html { redirect_to @bank_account, notice: 'Bank account was successfully created.' }
        format.json { render :show, status: :created, location: @bank_account }
      else
        format.html { render :new }
        format.json { render json: @bank_account.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /bank_accounts/1
  # PATCH/PUT /bank_accounts/1.json
  def update
    respond_to do |format|
      if @bank_account.update(bank_account_params)
        format.html { redirect_to @bank_account, notice: 'Bank account was successfully updated.' }
        format.json { render :show, status: :ok, location: @bank_account }
      else
        format.html { render :edit }
        format.json { render json: @bank_account.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bank_accounts/1
  # DELETE /bank_accounts/1.json
  def destroy
    @bank_account.destroy
    respond_to do |format|
      format.html { redirect_to bank_accounts_url, notice: 'Bank account was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bank_account
      @bank_account = BankAccount.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def bank_account_params
      params.require(:bank_account).permit(:marketplace, :bank_number, :agency_number, :agency_check_number, :account_number, :account_check_number, :bank_type, :doc_type, :doc_number, :fullname, :active)
    end
end
