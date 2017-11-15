class WheresController < ApplicationController
  before_action :set_where, only: [:show, :edit, :update, :destroy]
  before_filter :check_if_admin, only: [:index, :edit]

  def check_if_admin

    allowed_emails = [Rails.application.secrets[:admin_email], Rails.application.secrets[:admin_email_alt]]

    unless allowed_emails.include? current_user.email
      flash[:notice] = t('tours_controller_notice_one')
      redirect_to root_url
    end
  end

  def index
    @wheres = Where.all
  end

  def new
    @where = Where.new
  end

  # GET /backgrounds/1/edit
  def edit
  end

  def show
    @tours = Tour.joins(:wheres).where(wheres: {place_id: @where.place_id})
  end

  # POST /backgrounds
  # POST /backgrounds.json
  def create
    @where = Where.new(where_params)

    respond_to do |format|
      if @where.save
        format.html {
          redirect_to @where, notice: 'Background was successfully created.'
        }
        format.json { render :show, status: :created, location: @where }
      else
        format.html {
          flash[:errors] = @where.errors
          redirect_to :back, notice: 'Error to create background'
        }
        format.json { render json: @where.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /backgrounds/1
  # PATCH/PUT /backgrounds/1.json
  def update
    respond_to do |format|
      if @where.update(where_params)
        format.html { redirect_to @where, notice: 'Background was successfully updated.' }
        format.json { render :show, status: :ok, location: @where }
      else
        format.html { render :edit }
        format.json { render json: @where.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /backgrounds/1
  # DELETE /backgrounds/1.json
  def destroy
    @where.destroy
    respond_to do |format|
      format.html { redirect_to where_url, notice: 'Background was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  def set_where
    @where = Where.find(params[:id])
  end

  def where_params
    #params.require(:where).permit(:name, :background, :lat, :long, :city, :state, :country, :postal_code, :address, :google_id, :url, :place_id,
    #  { :backgrounds_attributes => [:name, :picture] }
    #)
    params.fetch(:where, {}).permit!
  end

end
