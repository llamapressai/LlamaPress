class StaticWebSitesController < ApplicationController
  before_action :set_static_web_site, only: %i[ show edit update destroy ]

  # GET /static_web_sites or /static_web_sites.json
  def index
    @static_web_sites = StaticWebSite.all
  end

  # GET /static_web_sites/1 or /static_web_sites/1.json
  def show
  end

  # GET /static_web_sites/new
  def new
    @static_web_site = StaticWebSite.new
  end

  # GET /static_web_sites/1/edit
  def edit
  end

  # POST /static_web_sites or /static_web_sites.json
  def create
    @static_web_site = StaticWebSite.new(static_web_site_params)

    respond_to do |format|
      if @static_web_site.save
        format.html { redirect_to static_web_site_url(@static_web_site), notice: "Static web site was successfully created." }
        format.json { render :show, status: :created, location: @static_web_site }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @static_web_site.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /static_web_sites/1 or /static_web_sites/1.json
  def update
    respond_to do |format|
      if @static_web_site.update(static_web_site_params)
        format.html { redirect_to static_web_site_url(@static_web_site), notice: "Static web site was successfully updated." }
        format.json { render :show, status: :ok, location: @static_web_site }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @static_web_site.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /static_web_sites/1 or /static_web_sites/1.json
  def destroy
    @static_web_site.destroy!

    respond_to do |format|
      format.html { redirect_to static_web_sites_url, notice: "Static web site was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_static_web_site
      @static_web_site = StaticWebSite.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def static_web_site_params
      params.require(:static_web_site).permit(:organization_id, :name, :slug)
    end
end
