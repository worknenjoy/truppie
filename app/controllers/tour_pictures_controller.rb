class TourPicturesController < ApplicationController
  before_action :set_tour_picture, only: [:show, :edit, :update, :destroy]

  # GET /tour_pictures
  # GET /tour_pictures.json
  def index
    @tour_pictures = TourPicture.all
  end

  # GET /tour_pictures/1
  # GET /tour_pictures/1.json
  def show
  end

  # GET /tour_pictures/new
  def new
    @tour_picture = TourPicture.new
  end

  # GET /tour_pictures/1/edit
  def edit
  end

  # POST /tour_pictures
  # POST /tour_pictures.json
  def create
    @tour_picture = TourPicture.new(tour_picture_params)

    respond_to do |format|
      if @tour_picture.save
        format.html { redirect_to @tour_picture, notice: 'Tour picture was successfully created.' }
        format.json { render :show, status: :created, location: @tour_picture }
      else
        format.html { render :new }
        format.json { render json: @tour_picture.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tour_pictures/1
  # PATCH/PUT /tour_pictures/1.json
  def update
    respond_to do |format|
      if @tour_picture.update(tour_picture_params)
        format.html { redirect_to @tour_picture, notice: 'Tour picture was successfully updated.' }
        format.json { render :show, status: :ok, location: @tour_picture }
      else
        format.html { render :edit }
        format.json { render json: @tour_picture.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tour_pictures/1
  # DELETE /tour_pictures/1.json
  def destroy
    @tour_picture.destroy
    respond_to do |format|
      format.html { redirect_to tour_pictures_url, notice: 'Tour picture was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tour_picture
      @tour_picture = TourPicture.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tour_picture_params
      params.require(:tour_picture).permit(:photo, :tour_id)
    end
end
