class BankAccountsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_bank_account, only: [:show, :edit, :update, :destroy, :activate]
  
  
  def activate
    if !@bank_account.own_id.nil?
      @activation_message = "Esta conta bancária do #{@bank_account.marketplace.organizer.name} já foi ativada"
      @activation_status = "danger"
      @errors = "já tem uma conta associada"
    else
      begin
        bank_account_active = @bank_account.marketplace.bank_account_active
        bank_register_status = bank_account_active.marketplace.register_bank_account
        if bank_register_status.id
          bank_account_active.own_id = bank_register_status.id
          if bank_account_active.save
            @activation_message = "Conta ativada com sucesso"
            @activation_status = "success"
            @response = bank_register_status
            MarketplaceMailer.activate_bank_account(@bank_account.marketplace.organizer).deliver_now
            return bank_register_status            
          else
            @activation_message = "Não conseguimos ativar a conta"
            @activation_status = "danger"
            @errors = "Não foi possível salvar a conta ativa"
          end
        else
          @activation_message = "Não foi possível ativar esta conta"
          @activation_status = "danger"
          @errors = "já tem uma conta associada"
        end
      rescue => e
        @activation_message = "Tivemos um problema pra ativar esta conta bancária"
        @activation_status = "danger"
        @errors = e.message
      end
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
      params.require(:bank_account).permit(:marketplace, :own_id, :bank_number, :agency_number, :agency_check_number, :account_number, :account_check_number, :bank_type, :doc_type, :doc_number, :fullname, :active)
    end
end
