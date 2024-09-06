class Account::StaticSitesController < Account::ApplicationController
  account_load_and_authorize_resource :static_site, through: :team, through_association: :static_sites

  # GET /account/teams/:team_id/static_sites
  # GET /account/teams/:team_id/static_sites.json
  def index
    delegate_json_to_api
  end

  # GET /account/static_sites/:id
  # GET /account/static_sites/:id.json
  def show
    delegate_json_to_api
  end

  # GET /account/teams/:team_id/static_sites/new
  def new
  end

  # GET /account/static_sites/:id/edit
  def edit
  end

  # POST /account/teams/:team_id/static_sites
  # POST /account/teams/:team_id/static_sites.json
  def create
    respond_to do |format|
      if @static_site.save
        format.html { redirect_to [:account, @static_site], notice: I18n.t("static_sites.notifications.created") }
        format.json { render :show, status: :created, location: [:account, @static_site] }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @static_site.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /account/static_sites/:id
  # PATCH/PUT /account/static_sites/:id.json
  def update
    respond_to do |format|
      if @static_site.update(static_site_params)
        format.html { redirect_to [:account, @static_site], notice: I18n.t("static_sites.notifications.updated") }
        format.json { render :show, status: :ok, location: [:account, @static_site] }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @static_site.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /account/static_sites/:id
  # DELETE /account/static_sites/:id.json
  def destroy
    @static_site.destroy
    respond_to do |format|
      format.html { redirect_to [:account, @team, :static_sites], notice: I18n.t("static_sites.notifications.destroyed") }
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
