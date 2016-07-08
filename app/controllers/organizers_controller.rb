class OrganizersController < ApplicationController
  before_action :set_organizer, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, :except => [:show]
  before_filter :check_if_admin, only: [:index, :new, :create, :update]
  
  def check_if_admin
    
    allowed_emails = ["laurinha.sette@gmail.com", "alexanmtz@gmail.com"]
    
    unless allowed_emails.include? current_user.email
      flash[:notice] = "Você não está autorizado a entrar nesta página"
      redirect_to root_url
    end 
  end

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

  # GET /organizers/1/edit
  def edit
  end

  # POST /organizers
  # POST /organizers.json
  def create
    @organizer = Organizer.new(organizer_params)

    respond_to do |format|
      if @organizer.save
        format.html { redirect_to @organizer, notice: 'Organizer was successfully created.' }
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
        format.html { redirect_to @organizer, notice: 'Organizer was successfully updated.' }
        format.json { render :show, status: :ok, location: @organizer }
      else
        format.html { render :edit, error: 'Não foi possível atualizar' }
        format.json { render json: @organizer.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def account_activate
    @organizer = Organizer.find(params[:id])
    
    if @organizer.valid_account
        
          account_bank_data = @organizer.bank_data
          
          if @organizer.account_id
            #consult
            flash[:notice] = "Voce ja tem uma conta associada com o ID #{@organizer.account_id}"
          else
            @response = RestClient.post "https://sandbox.moip.com.br/v2/accounts", account_bank_data.to_json, :content_type => :json, :accept => :json, :authorization => "OAuth jdyi6e28vdyz2l8e1nss0jadh1j4ay2"
            
            response_json = JSON.load @response
            
            if !response_json["errors"].nil? 
              flash[:notice] = response_json["error"][0]["description"]
            else
            
              if !response_json["id"].nil? 
                @organizer.update_attribute("account_id",  response_json["id"])            
              end
              
              if !response_json["accessToken"].nil?
                @organizer.update_attribute("token",  response_json["accessToken"])            
              end
              
              if response_json["email"]["address"] == @organizer.email && @organizer.id && @organizer.token
                flash[:notice] = "Conta ativada"
                @organizer.update_attribute("active",  true)
              else
                flash[:notice] = "Por algum motivo a conta não foi ativada"
              end
            end
            
            #id MPA-8498C89C7F06
            #token 593ca56aefbd462898f954e4c13fc415_v2
            #mkid APP-FAW8Z1CC1JNB
          end
    else
        @organizer.update_attribute("active",  false)
        puts @organizer.inspect
        flash[:notice] = "É necessário preencher todos os dados do titular da conta"
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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_organizer
      @organizer = Organizer.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def organizer_params
      
      if params[:organizer][:members] == "" or params[:organizer][:members].nil?
        params[:organizer][:members] = []
      end
        
      params.fetch(:organizer, {}).permit(:name, :description, :picture, :user_id, :where, :email, :website, :facebook, :twitter, :instagram, :phone, :logo, :person_name, :person_lastname, :document_type, :document_number, :id_type, :id_number, :id_issuer, :id_issuerdate, :birthDate, :street, :street_number, :complement, :district, :zipcode, :city, :state, :country, :token, :account_id, :members)
    end
end
