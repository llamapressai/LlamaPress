class Account::StaticSitePagesController < Account::ApplicationController
  account_load_and_authorize_resource :static_site_page, through: :static_site, through_association: :static_site_pages

  # GET /account/static_sites/:static_site_id/static_site_pages
  # GET /account/static_sites/:static_site_id/static_site_pages.json
  def index
    delegate_json_to_api
  end

  # GET /account/static_site_pages/:id
  # GET /account/static_site_pages/:id.json
  def show
    delegate_json_to_api
  end

  # GET /account/static_sites/:static_site_id/static_site_pages/new
  def new
  end

  # GET /account/static_site_pages/:id/edit
  def edit
  end

  # POST /account/static_sites/:static_site_id/static_site_pages
  # POST /account/static_sites/:static_site_id/static_site_pages.json
  def create
    respond_to do |format|
      if @static_site_page.save
        format.html { redirect_to [:account, @static_site_page], notice: I18n.t("static_site_pages.notifications.created") }
        format.json { render :show, status: :created, location: [:account, @static_site_page] }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @static_site_page.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /account/static_site_pages/:id
  # PATCH/PUT /account/static_site_pages/:id.json
  def update
    respond_to do |format|
      if @static_site_page.update(static_site_page_params)
        format.html { redirect_to [:account, @static_site_page], notice: I18n.t("static_site_pages.notifications.updated") }
        format.json { render :show, status: :ok, location: [:account, @static_site_page] }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @static_site_page.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /account/static_site_pages/:id
  # DELETE /account/static_site_pages/:id.json
  def destroy
    @static_site_page.destroy
    respond_to do |format|
      format.html { redirect_to [:account, @static_site, :static_site_pages], notice: I18n.t("static_site_pages.notifications.destroyed") }
      format.json { head :no_content }
    end
  end

  private

  if defined?(Api::V1::ApplicationController)
    include strong_parameters_from_api
  end

  def process_params(strong_params)
    # 🚅 super scaffolding will insert processing for new fields above this line.
  end
end
