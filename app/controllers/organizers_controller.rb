class OrganizersController < ApplicationController
  include ApplicationHelper
  before_action :set_organizer, only: [:show, :edit, :update, :destroy, :transfer, :guided_tour, :external_events, :import_events]
  before_action :authenticate_user!, :except => [:show]
  before_filter :check_if_admin, only: [:index, :new, :create, :update, :manage, :transfer, :transfer_funds, :tos_acceptance, :external_events]
  
  # GET /organizers
  # GET /organizers.json
  def index
    @organizers = Organizer.all
  end

  # GET /organizers/1
  # GET /organizers/1.json
  def show

  end

  # GET /organizers/new
  def new
    @organizer = Organizer.new
  end

  def guided_tour
    @guided_tour = @organizer.tours.new
  end

  def edit_guided_tour
    @guided_tour = Tour.find(params[:tour])
    @organizer = Organizer.find(params[:id])
  end

  # GET /organizers/1/edit
  def edit
  end

  # POST /organizers
  # POST /organizers.json
  def create
    @organizer = Organizer.new(organizer_params)

    respond_to do |format|
      if @organizer.save
        format.html {
          OrganizerMailer.notify(@organizer, "activate").deliver_now 
          redirect_to @organizer, notice: 'Organizer was successfully created.' 
        }
        format.json { render :show, status: :created, location: @organizer }
      else
        format.html { render :new }
        format.json { render json: @organizer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /organizers/1
  # PATCH/PUT /organizers/1.json
  def update
    respond_to do |format|
      if @organizer.update(organizer_params)
        format.html { 
          #OrganizerMailer.notify(@organizer, "update").deliver_now
          redirect_to @organizer, notice: 'Organizer was successfully updated.'
        }
        format.json { render :show, status: :ok, location: @organizer }
      else
        format.html { render :edit }
        format.json { render json: @organizer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /organizers/1
  # DELETE /organizers/1.json
  def destroy
    @organizer.destroy
    respond_to do |format|
      format.html { redirect_to organizers_url, notice: 'Organizer was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  def dashboard
    @organizer = Organizer.find(params[:id])
    @tours = @organizer.tours.order('created_at DESC')
    if params[:tour].nil? 
      @tour = @organizer.tours.order('created_at DESC').first
    else
      @tour = Tour.find(params[:tour])
    end
  end
  
  def manage
    @organizer = Organizer.find(params[:id])
    @tours = @organizer.tours.order('created_at DESC')
    if params[:tour].nil? 
      @tour = @organizer.tours.order('created_at DESC').first
    else
      @tour = Tour.find(params[:tour])
    end
  end

  def schedule
    @organizer = Organizer.find(params[:id])
  end

  def clients
    @organizer = Organizer.find(params[:id])
  end

  def import_events
    events = params["events"]
    @token = params["facebook_token"]
    @user_id = params["facebook_user_id"]

    if !events.nil?
      @response = []
      events.each do |e|
        @response.push JSON.load RestClient.get("https://graph.facebook.com/v2.9/#{e}", :content_type => :json, :accept => :json, :authorization => "OAuth #{@token}")
      end

      @response.each do |r|

        @photo = JSON.load RestClient.get("https://graph.facebook.com/v2.9/#{r["id"]}/?fields=cover", :content_type => :json, :accept => :json, :authorization => "OAuth #{@token}")

        @tour = Tour.new({
          title: r["name"],
          start: r["start_time"],
          end: r["end_time"] || r["start_time"],
          description: r["description"],
          organizer: @organizer,
          where: Where.create({:name => r["place"]["name"]}),
          value: 20,
          photo: @photo["cover"]["source"],
          link: "http://www.facebook.com/events/#{r["id"]}",
          user: @organizer.user
        })
        if @tour.save
          flash[:success] = "evento importado com sucesso"
        else
          puts "not saved"
          puts @tour.errors.inspect
          flash[:error] = "não foi possivel importar o evento"
        end
      end
    else
      flash[:error] = "não foi possivel importar o evento"
      redirect_to "/organizers/#{@organizer.to_param}/guided_tour"
      return
    end
    redirect_to "/organizers/#{@organizer.to_param}/edit_guided_tour/#{@tour.to_param}"
  end

  def external_events
    @source = params[:source]
    @token = params[:token]
    @user_id = params[:user_id]
    if @token && @user_id
      @response = RestClient.get("https://graph.facebook.com/v2.9/#{@user_id}/events?type=created&limit=5", :content_type => :json, :accept => :json, :authorization => "OAuth #{@token}")
      @response_json = JSON.load @response
    else
      render :status => 404
    end
    #puts @response_json.inspect
    #https://www.facebook.com/v2.9/dialog/oauth?response_type=token&display=popup&client_id=1696671210617842&redirect_uri=https%3A%2F%2Fdevelopers.facebook.com%2Ftools%2Fexplorer%2Fcallback%3Fmethod%3DGET%26path%3D10154033067028556%252Fevents%253Ftype%253Dcreated%2526limit%253D2%26version%3Dv2.9&scope=rsvp_event%2Cuser_events
  end
  
  def confirm_account
    @organizer = Organizer.find(params[:id])
    @marketplace = @organizer.marketplace
  end
  
  def tos_acceptance
    @organizer = Organizer.find(params[:id])
  end
  
  def tos_acceptance_confirm
    @organizer = Organizer.find(params[:id])
    if Rails.env.development?
      @ip = "127.0.0.1"
    else
      @ip = params[:ip]
    end 
    
    if request.post?
      begin 
        valid_ip = IPAddr.new(@ip)
      rescue
        @status = "danger"
        @status_message = e.message
      end
      
     if valid_ip
        if @organizer.try(:marketplace)
          begin
            accepted = @organizer.marketplace.accept_terms(@ip)
          rescue => e
            @status = "danger"
            puts e.inspect
            @status_message = "Erro ao requisitar o stripe"
          end
          if accepted
            @status = "success"
            @status_message = "Seus termos foram aceitos com sucesso"
          else
            @status = "danger"
            @status_message = "Não conseguimos validar seus termos com o Stripe"
          end
        else
          @status = "danger"
          @status_message = "Você ainda não está cadastrado no Marketplace de guias"
        end
     else
        @status = "danger"
        @status_message = "Não foi possível aceitar seus termos. Não conseguimos obter seu IP para identificá-lo"
     end
   else
    @status = "danger"
    @status_message = "Não foi possível aceitar seus termos"
   end
    
  end
  
  def transfer
    @organizer = Organizer.find(params[:id])
    @bank_account = []
    if @organizer.try(:marketplace)
      @balance = @organizer.marketplace.balance
      @transfers = @organizer.marketplace.transfers
      @bank_account.push(@organizer.marketplace.bank_account_active)
    else
      @transfers = []
      @balance = {}
    end
  end
  
  #deprecated - convert to stripe manual transfer (the money is transfered automatically)
  def transfer_funds
    @organizer = Organizer.find(params[:id])
    @amount = raw_price(params[:amount])
    @current = raw_price(params[:current])
    
    if params[:amount].nil?
      @status = "danger"
      @message_status = "Você não especificou um valor"
      return 
    end
    
    @bank_account_active_id = @organizer.marketplace.bank_account_active.own_id
    if @bank_account_active_id.nil?
      @status = "danger"
      @message_status = "Você não tem nenhuma conta bancária ativa no momento"
    else
      if @amount <= @current
         bank_transfer_data = {
              "amount" => @amount,
              "transferInstrument" => {
                  "method" => "BANK_ACCOUNT",
                  "bankAccount" => {
                      "id" => @bank_account_active_id,
                  }
              }
          }
          response_transfer = RestClient.post("#{Rails.application.secrets[:moip_domain]}/transfers", bank_transfer_data.to_json, :content_type => :json, :accept => :json, :authorization => "OAuth #{@organizer.marketplace.token}"){|response, request, result, &block| 
              case response.code
                when 401
                  @status = "danger"
                  @message_status = "Você não está autorizado a realizar esta transação"
                  @response_transfer_json = JSON.load response
                when 400 
                  @status = "danger"
                  @message_status = "Não foi possíel realizar a transferência"
                  @response_transfer_json = JSON.load response
                when 200
                  @status = "danger"
                  @message_status = "Não foi possível realizar a transferência"
                  @response_transfer_json = JSON.load response
                when 201
                  @status = "success"
                  @message_status = "Solicitação de transferência realizada com sucesso"
                  @response_transfer_json = JSON.load response
                  MarketplaceMailer.transfer(@organizer, friendly_price(@response_transfer_json["amount"]), l(@response_transfer_json["updatedAt"].to_datetime, format: '%d de %B de %Y as %Hh%M')).deliver_now
                else
                  @activation_message = "Não conseguimos resposta do MOIP para a transferência soliticata, verifique os dados novamente."
                  @activation_status = "danger"
                  @response_transfer_json = JSON.load response
                end
          }
      else
         @status = "danger"
         @message_status = "Você não tem fundos suficientes para realizar esta transferência"
      end
    end
    
  end
  
  def marketplace
    
  end

  private
  
    # Use callbacks to share common setup or constraints between actions.
    def set_organizer
      @organizer = Organizer.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def organizer_params
      split_val = ";"
      
      if params[:organizer][:members] == "" or params[:organizer][:members].nil?
        params[:organizer][:members] = []
      else
        members_to_array = params[:organizer][:members].split(split_val)
        members = []
        members_to_array.each do |m|
          members.push User.find_by_name(m)
        end
        params[:organizer][:members] = members
      end
      
      if params[:organizer][:policy] == "" or params[:organizer][:policy].nil?
        params[:organizer][:policy] = []
      else
        included_to_array = params[:organizer][:policy].split(split_val)
        included = []
        included_to_array.each do |i|
          included.push i
        end
        params[:organizer][:policy] = included
      end
      
      params.fetch(:organizer, {}).permit(:name, :marketplace_id, :description, :picture, :user_id, :where, :email, :website, :facebook, :twitter, :instagram, :phone, :status, :members, :policy).merge(params[:organizer])
    end
end
