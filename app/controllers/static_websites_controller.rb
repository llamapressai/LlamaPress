class StaticWebsitesController < ApplicationController
  before_action :set_static_website, only: %i[ show edit update destroy ]

  # GET /static_websites or /static_websites.json
  def index
    @static_websites = StaticWebsite.all
  end

  # GET /static_websites/1 or /static_websites/1.json
  def show
  end

  # GET /static_websites/new
  def new
    @static_website = StaticWebsite.new
  end

  # GET /static_websites/1/edit
  def edit
  end

  # POST /static_websites or /static_websites.json
  def create
    @static_website = StaticWebsite.new(static_website_params)

    respond_to do |format|
      if @static_website.save
        format.html { redirect_to static_website_url(@static_website), notice: "Static website was successfully created." }
        format.json { render :show, status: :created, location: @static_website }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @static_website.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /static_websites/1 or /static_websites/1.json
  def update
    respond_to do |format|
      if @static_website.update(static_website_params)
        format.html { redirect_to static_website_url(@static_website), notice: "Static website was successfully updated." }
        format.json { render :show, status: :ok, location: @static_website }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @static_website.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /static_websites/1 or /static_websites/1.json
  def destroy
    @static_website.destroy!

    respond_to do |format|
      format.html { redirect_to static_websites_url, notice: "Static website was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_static_website
      @static_website = StaticWebsite.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def static_website_params
      params.require(:static_website).permit(:organization_id, :name, :slug)
    end
end
