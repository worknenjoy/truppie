class BankAccountsController < ApplicationController
  before_action :set_bank_account, only: [:show, :edit, :update, :destroy]
  
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
        @account = RestClient.post "https://sandbox.moip.com.br/v2/accounts/#{@bank_account.organizer.account_id}/bankaccounts", @bank_account.account_info.to_json, :content_type => :json, :accept => :json, :authorization => "OAuth #{@bank_account.organizer.token}"
        
        @account_json = JSON.load @account
        
        puts @account_json.inspect
        
        if !@account_json["id"]
          @bank_account.update_attribute('uid', @account_json["id"])
          format.html { 
            redirect_to @bank_account,
            notice: "ID updated to #{@account_json['id']}"
          }
        else
          format.html { 
            redirect_to @bank_account,
            notice: 'Could not find id'
          }
        end
        
        format.html { 
          redirect_to @bank_account,
          notice: 'Bank account was successfully created.' 
        }
        format.json { render :show, status: :created, location: @bank_account }
      else
        format.html { redirect_to @bank_account, notice: "Não foi possível criar conta" }
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
      params.require(:bank_account).permit(:bankNumber, :agencyNumber, :agencyCheckNumber, :accountNumber, :accountCheckNumber, :type, :doc_type, :doc_number, :fullname, :organizer_id, :uid)
    end
end
