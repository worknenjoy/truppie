class OrganizersController < ApplicationController
  before_action :set_organizer, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, :except => [:show]
  before_filter :check_if_admin, only: [:index, :new, :create, :update, :manage]
  
  def check_if_admin
    allowed_emails = ["laurinha.sette@gmail.com", "alexanmtz@gmail.com"]
    
    if params[:controller] == "organizers" and params[:action] == "manage"
      organizer_id = params[:id]
      allowed_emails.push Organizer.find(organizer_id).user.email
    end
    
    unless allowed_emails.include? current_user.email
      flash[:notice] = "Você não está autorizado a entrar nesta página"
      redirect_to new_user_session_path
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
  
  def manage
    @organizer = Organizer.find(params[:id])
    @tours = @organizer.tours.order('updated_at DESC')
    if params[:tour].nil? 
      @tour = @organizer.tours.first
    else
      @tour = Tour.find(params[:tour])  
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_organizer
      @organizer = Organizer.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def organizer_params
      
      
      
      params.fetch(:organizer, {}).permit(:name, :description, :picture, :user_id, :where, :email, :website, :facebook, :twitter, :instagram, :phone)
    end
end
