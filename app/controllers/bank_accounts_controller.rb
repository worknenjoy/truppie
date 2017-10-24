class BankAccountsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_bank_account, only: [:show, :edit, :update, :destroy, :activate]
  before_filter :check_if_super_admin, only: [:index, :new, :edit]
  before_filter :check_if_organizer_admin, only: [:activate, :create, :update, :destroy]

  def activate
    if !@bank_account.own_id.nil?
      @activation_message = t('bank_controller_activation_msg_one', organizer: @bank_account.marketplace.organizer.name)
      @activation_status = t('bank_controller_activation_msg_status_one')
      @errors = t('bank_controller_activation_errors')
    else
      begin
        bank_account_active = @bank_account.marketplace.bank_account_active
        bank_register_status = bank_account_active.marketplace.register_bank_account
        if bank_register_status.id
          bank_account_active.own_id = bank_register_status.id
          if bank_account_active.save
            @activation_message = t('bank_controller_activation_msg_two')
            @activation_status = t('bank_controller_activation_msg_status_two')
            @response = bank_register_status
            MarketplaceMailer.activate_bank_account(@bank_account.marketplace.organizer).deliver_now
            return bank_register_status            
          else
            @activation_message = t('bank_controller_activation_msg_three')
            @activation_status = t('bank_controller_activation_msg_status_one')
            @errors = t('bank_controller_activation_errors_two')
          end
        else
          @activation_message = t('bank_controller_activation_msg_four')
          @activation_status = t('bank_controller_activation_msg_status_one')
          @errors = t('bank_controller_activation_errors')
        end
      rescue => e
        @activation_message = t('bank_controller_activation_msg_five')
        @activation_status = t('bank_controller_activation_msg_status_one')
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
        format.html {
          if bank_account_params[:marketplace_id]
            @marketplace = Marketplace.find(bank_account_params[:marketplace_id])
            @marketplace.bank_accounts << @bank_account
            @bank_account.update_attributes({:marketplace => @marketplace })
            begin
              bank_register_status = @bank_account.register
              puts 'bank register'
              puts bank_register_status.inspect
            rescue => e
              ContactMailer.notify("Não foi possível registrar a conta bancária. Reason:#{e.inspect}, bank_account #{@bank_account.inspect}")
              puts e.inspect
              redirect_to :back, notice: t("bank-account-data-remote-incorrect")
              return
            end
          end
          redirect_to :back, notice: t('bank_account_controller_notice_two')
        }
        format.json { render :show, status: :created, location: @bank_account }
      else
        format.html {
          flash[:errors] = @bank_account.errors
          redirect_to :back, notice: t("bank-account-data-incorrect")
        }
        format.json { render json: @bank_account.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /bank_accounts/1
  # PATCH/PUT /bank_accounts/1.json
  def update
    respond_to do |format|
      if @bank_account.update(bank_account_params)
        format.html {
          begin
            if @bank_account.own_id
              @bank_account_sync = @bank_account.sync
              if @bank_account_sync
                @status_message = I18n.t('bank-account-sync-sucessfully')
              else
                @status_message = I18n.t('bank-account-sync-issue')
              end
            else
              @bank_account_register = @bank_account.register
              if @bank_account_register
                @status_message = I18n.t('bank-account-register-sucessfully')
              else
                @status_message = I18n.t('bank-account-register-issue')
              end
            end
          rescue ArgumentError => e
            puts 'Missing id error'
            puts e.inspect
            @status_message = I18n.t('bank-account-sync-error-no-id')
          rescue => e
            puts 'bank account sync error'
            puts e.inspect
            @status_message = I18n.t('bank-account-sync-error')
          end
          redirect_to :back, notice: @status_message || t('bank-account-updated')
        }
        format.json { render :show, status: :ok, location: @bank_account }
      else
        format.html {
          flash[:errors] = @bank_account.errors
          redirect_to :back, notice: t('bank-account-updated-fail')
        }
        format.json { render json: @bank_account.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bank_accounts/1
  # DELETE /bank_accounts/1.json
  def destroy
      respond_to do |format|
        begin
          @bank_account.fetch.delete()
          format.html {
            @bank_account.destroy
            redirect_to :back, notice: I18n.t('bank-account-destroyed-successfully')
          }
          format.json { head :no_content }
        rescue Stripe::InvalidRequestError => e
          format.html {
            puts e.inspect
            redirect_to :back, notice: I18n.t('bank-account-not-deleted-default')
          }
        rescue => e
          format.html {
            puts e.inspect
            redirect_to :back, notice: I18n.t('bank-account-not-deleted')
          }
        end
      end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bank_account
      @bank_account = BankAccount.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def bank_account_params
      params.require(:bank_account).permit(:marketplace, :marketplace_id, :own_id, :bank_number, :agency_number, :agency_check_number, :account_number, :account_check_number, :bank_type, :doc_type, :doc_number, :fullname, :active)
    end
end
