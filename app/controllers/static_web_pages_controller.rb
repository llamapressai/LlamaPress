class StaticWebPagesController < ApplicationController
  before_action :set_static_web_page, only: %i[ show edit update destroy ]
  skip_before_action :authenticate_user!, only: [:home]
  skip_before_action :verify_authenticity_token, only: [:restore] 

  # GET /
  # Find and render the root page depending on the domain.
  # If no root page is found, redirect to the llama press home page.
  def home
    domain = request.env["HTTP_HOST"].dup
    domain.slice! "www."
    Rails.logger.info("Domain request for: " + domain)

    @static_web_site = StaticWebSite.find_by(slug: domain)

    if @static_web_site.present?
      @static_web_page = @static_web_site.static_web_pages.find_by(slug: '/')
      if @static_web_page.nil?
        redirect_to llama_bot_home_path and return
      end
    else # if no site is found for this domain, just go to the llamabot dashboard.
      redirect_to llama_bot_home_path and return 
    end

    content = @static_web_page.content
    content += inject_chat_partial(content) if current_user.present?
    render inline: content.html_safe, layout: 'static_web_page'
  end

  # GET /static_web_pages or /static_web_pages.json
  def index
    @static_web_pages = current_organization.static_web_pages
  end

  # GET /static_web_pages/1 or /static_web_pages/1.json
  def show
    content = @static_web_page.content

    # Inject the chat partial
    content += inject_chat_partial(content)
    render inline: content.html_safe, layout: 'static_web_page'
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

  def histories
    @static_web_page = StaticWebPage.find(params[:id])
    @static_web_page_histories = @static_web_page.static_web_page_histories.order(created_at: :desc)
    respond_to do |format|
      format.html # Renders the default history.html.erb view
      format.json do
        encoded_histories = @static_web_page_histories.map do |history|
          history_data = history.as_json
          history_data['content'] = Base64.strict_encode64(history.content)
          history_data
        end
        encoded_histories_json_object = { web_page_histories: encoded_histories }
        render json: encoded_histories_json_object
      end
    end
  end

  def restore
    @static_web_page_history = StaticWebPageHistory.find(params[:static_web_page_history_id])
    @static_web_page.restore(@static_web_page_history)
    
    respond_to do |format|
      format.html { redirect_to static_web_page_path(@static_web_page), notice: "Static web page was successfully restored." }
      format.json { render json: { message: "Static web page restored successfully", static_web_page: @static_web_page }, status: :ok }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_static_web_page
      @static_web_page = StaticWebPage.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def static_web_page_params
      params.require(:static_web_page).permit(:static_web_site_id, :content, :slug, :prompt, :organization_id)
    end

    def inject_chat_partial(content)
      render_to_string(partial: 'shared/llama_bot/chat')
    end
end
