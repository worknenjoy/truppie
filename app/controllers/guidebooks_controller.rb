class GuidebooksController < ApplicationController
  before_action :set_guidebook, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, :except => [:show]
  before_filter :check_if_admin, only: [:index, :new, :create, :update, :destroy]

  def check_if_admin

    allowed_emails = [Rails.application.secrets[:admin_email], Rails.application.secrets[:admin_email_alt]]

    unless allowed_emails.include? current_user.email
      flash[:notice] = t('tours_controller_notice_one')
      redirect_to root_url
    end
  end

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

      split_val = ";"
      organizer = params[:guidebook][:organizer_id] || params[:guidebook][:organizer]


      if organizer.class == String
        new_organizer = Organizer.find_by_name(organizer)

        unless new_organizer.nil?
          new_user = new_organizer.user
          params[:guidebook][:user] = new_user
          params[:guidebook][:organizer] = new_organizer
        end
      end

      if params[:guidebook][:tags] == "" or params[:guidebook][:tags].nil?
        params[:guidebook][:tags] = []
      else
        tags_to_array = params[:guidebook][:tags].split(split_val)
        tags = []
        tags_to_array.each do |t|
          tags.push Tag.find_or_create_by(name: t)
        end
        params[:guidebook][:tags] = tags
      end

      if params[:guidebook][:languages] == "" or params[:guidebook][:languages].nil?
        params[:guidebook][:languages] = []
      else
        langs_to_array = params[:guidebook][:languages].split(split_val)
        langs = []
        langs_to_array.each do |l|
          langs.push Language.find_or_create_by(name: l)
        end
        params[:guidebook][:languages] = langs
      end

      pkg_attr = params[:guidebook][:packages]

      if !pkg_attr.nil?
        post_data = []
        pkg_attr.each do |p|
          included_array = p[1]["included"].split(split_val)
          post_data.push Package.create(name: p[1]["name"], value: p[1]["value"], percent: p[1]["percent"], included: included_array)
        end
        params[:guidebook][:packages] = post_data
      end

      if params[:guidebook][:included] == "" or params[:guidebook][:included].nil?
        params[:guidebook][:included] = []
      else
        included_to_array = params[:guidebook][:included].split(split_val)
        included = []
        included_to_array.each do |i|
          included.push i
        end
        params[:guidebook][:included] = included
      end

      if params[:guidebook][:nonincluded] == "" or params[:guidebook][:nonincluded].nil?
        params[:guidebook][:nonincluded] = []
      else
        nonincluded_to_array = params[:guidebook][:nonincluded].split(split_val)
        nonincluded = []
        nonincluded_to_array.each do |i|
          nonincluded.push i
        end
        params[:guidebook][:nonincluded] = nonincluded
      end

      current_category = params[:guidebook][:category]

      if current_category == "" or current_category.nil?
        params[:guidebook][:category] = Category.find_or_create_by(name: 'Outras')
      else
        begin
          params[:guidebook][:category] = Category.find(current_category)
        rescue => e
          params[:guidebook][:category] = Category.find_or_create_by(name: current_category)
        end
      end

      params[:guidebook][:currency] = "BRL"

      # unpermitted params error even with all params provided
      #params.fetch(:guidebook, {}).permit!(:title, :category_id, :organizer, :user, {:tags => [:id, :name]}, {:languages => [:id, :name]}, {:category => [:id, :name]}, :status, {:packages_attributes => [:id, :name, :value, :included, :description, :percent]}, {:wheres_attributes => [:id, :name, :place_id, :background_id, :lat, :long, :city, :state, :country, :postal_code, :address, :google_id, :url]}, :picture, :file, :value, :description, {:included => []}, {:nonincluded => []}, :currency).merge(params[:guidebook])
      params.fetch(:guidebook, {}).permit!
    end
end
