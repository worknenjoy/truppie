class GuidebooksController < ApplicationController
  before_action :set_guidebook, only: [:show, :edit, :update, :destroy]

  # GET /guidebooks
  # GET /guidebooks.json
  def index
    @guidebooks = Guidebook.all
  end

  # GET /guidebooks/1
  # GET /guidebooks/1.json
  def show
  end

  # GET /guidebooks/new
  def new
    @guidebook = Guidebook.new
  end

  # GET /guidebooks/1/edit
  def edit
  end

  # POST /guidebooks
  # POST /guidebooks.json
  def create
    @guidebook = Guidebook.new(guidebook_params)

    respond_to do |format|
      if @guidebook.save
        format.html { redirect_to @guidebook, notice: 'Guidebook was successfully created.' }
        format.json { render :show, status: :created, location: @guidebook }
      else
        format.html { render :new }
        format.json { render json: @guidebook.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /guidebooks/1
  # PATCH/PUT /guidebooks/1.json
  def update
    respond_to do |format|
      if @guidebook.update(guidebook_params)
        format.html { redirect_to @guidebook, notice: 'Guidebook was successfully updated.' }
        format.json { render :show, status: :ok, location: @guidebook }
      else
        format.html { render :edit }
        format.json { render json: @guidebook.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /guidebooks/1
  # DELETE /guidebooks/1.json
  def destroy
    @guidebook.destroy
    respond_to do |format|
      format.html { redirect_to guidebooks_url, notice: 'Guidebook was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_guidebook
      @guidebook = Guidebook.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def guidebook_params
      params.require(:guidebook).permit(:title, :description, :rating, :value, :currency, :organizer_id, :user_id, :privacy, :verified, :status, :included, :nonincluded)
    end
end
