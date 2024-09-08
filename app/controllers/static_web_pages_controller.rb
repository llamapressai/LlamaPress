class StaticWebPagesController < ApplicationController
  before_action :set_static_web_page, only: %i[ show edit update destroy ]

  # GET /static_web_pages or /static_web_pages.json
  def index
    @static_web_pages = current_organization.static_web_pages
  end

  # GET /static_web_pages/1 or /static_web_pages/1.json
  def show
  end

  # GET /static_web_pages/new
  def new
    @static_web_page = current_organization.static_web_pages.build
  end

  # GET /static_web_pages/1/edit
  def edit
  end

  # POST /static_web_pages or /static_web_pages.json
  def create
    @static_web_page = current_organization.static_web_pages.build(static_web_page_params)

    respond_to do |format|
      if @static_web_page.save
        format.html { redirect_to static_web_page_url(@static_web_page), notice: "Static web page was successfully created." }
        format.json { render :show, status: :created, location: @static_web_page }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @static_web_page.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /static_web_pages/1 or /static_web_pages/1.json
  def update
    respond_to do |format|
      if @static_web_page.update(static_web_page_params)
        format.html { redirect_to static_web_page_url(@static_web_page), notice: "Static web page was successfully updated." }
        format.json { render :show, status: :ok, location: @static_web_page }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @static_web_page.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /static_web_pages/1 or /static_web_pages/1.json
  def destroy
    @static_web_page.destroy!

    respond_to do |format|
      format.html { redirect_to static_web_pages_url, notice: "Static web page was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_static_web_page
      @static_web_page = StaticWebPage.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def static_web_page_params
      params.require(:static_web_page).permit(:static_web_site_id, :content, :slug, :prompt)
    end
end
