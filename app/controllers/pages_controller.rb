require 'diffy'

class PagesController < ApplicationController
  before_action :set_page, only: %i[ show edit update destroy restore preview]
  skip_before_action :authenticate_user!, only: [:home, :resolve_slug, :show]
  skip_before_action :verify_authenticity_token, only: [:restore, :update]

  # GET /
  # Find and render the root page depending on the domain.
  # If no root page is found, redirect to the llama press home page.
  def home
    #If the user is signed in, and they have a default site, redirect to that site's home page.

    #If no user, no site, no page, no domain.
    if current_site.present? #current_site is set in application_controller.rb, based on domain that's requesting.
      @page = current_site.pages.first
      if @page.nil?
        redirect_to llama_bot_home_path and return
      end
    else # if no site is found for this domain, go to the default home page. 
      if current_user.present?
        if current_user.organization.pages.count == 0
          redirect_to llama_bot_home_path and return
        else 
          @page = current_user.organization.pages.first
          redirect_to "/pages/#{@page.id}" and return
        end
      else
        redirect_to new_user_registration_path and return 
      end
    end

    content = @page.render_content
    content += inject_chat_partial(content) if current_user.present?
    content += inject_style()
    content += inject_analytics_partial() if Rails.env.production?
    render inline: content.html_safe, layout: 'page'
  end

  def resolve_slug
    #Handle duplicate slugs. Default to current_site's version, but if it can't find current_site's version, try the global version.
    @page = current_site&.pages&.friendly&.find(params[:path]) || Page.find_by(slug: params[:path])
    
    if @page.nil?
      redirect_to llama_bot_home_path and return
    end
    
    content = @page.render_content
    content += inject_chat_partial(content) if current_user.present?
    content += inject_analytics_partial() if Rails.env.production?
    render inline: content.html_safe, layout: 'page'
  end

  # GET /pages or /pages.json
  def index
    if current_site.present?
      @pages = current_site.pages
    else
      @pages = current_organization.pages
    end

    respond_to do |format|
      format.html
      format.json do
        render json: @pages
      end
    end
  end

  # GET /pages/1 or /pages/1.json
  def show
    content = @page.render_content

    # Inject the chat partial
    content += inject_chat_partial(content) if current_user.present?
    content += inject_analytics_partial() if Rails.env.production?
    render inline: content.html_safe, layout: 'page'
  end

  # GET /pages/new
  def new
    @page = current_organization.pages.build
    @site_id = params[:site_id].present? ? params[:site_id] : current_site.id
  end

  # GET /pages/1/edit
  def edit
  end

  # GET /pages/1/preview
  def preview
    content = @page.render_content
    render inline: content.html_safe, layout: 'page'
  end

  # POST /pages or /pages.json
  def create
    if params[:site_id].present? #associate it with the right site if it's passed in
      @site = Site.find(params[:site_id])
      @page = @site.pages.build(page_params)
    else
      @page = current_organization.pages.build(page_params) #otherwise this will default to the current site, or first site found in this organization.
    end

    respond_to do |format|
      if @page.save
        format.html { redirect_to page_url(@page), notice: "web page was successfully created." }
        format.json { render :show, status: :created, location: @page }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @page.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /pages/1 or /pages/1.json
  def update
    message = params[:message].present? ? params[:message] : "User Edit"
    @page.save_history(message)
    respond_to do |format|
      if @page.update(page_params)
        format.html { redirect_to page_url(@page), notice: "web page was successfully updated." }
        format.json { render :show, status: :ok, location: @page }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @page.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pages/1 or /pages/1.json
  def destroy
    @page.destroy!

    respond_to do |format|
      format.html { redirect_to pages_url, notice: "web page was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def histories
    @page = Page.find(params[:id])
    @page_histories = @page.page_histories.order(created_at: :desc)
    respond_to do |format|
      format.html # Renders the default history.html.erb view
      format.json do
        encoded_histories = @page_histories.map do |history|
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
    @page_history = PageHistory.find(params[:page_history_id])
    @page.restore(@page_history)
    
    respond_to do |format|
      format.html { redirect_to page_path(@page), notice: "web page was successfully restored." }
      format.json { render json: { message: "web page restored successfully", page: @page }, status: :ok }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_page
      @page = Page.friendly.find(params[:id]) || Page.find(params[:id])
    end

    def set_site
      if page_params[:site_id].present?
        @site = Site.find(params[:site_id])
      else
        @site = current_site || @page.site || current_organization.sites.first
      end
    end

    # Only allow a list of trusted parameters through.
    def page_params
      params.require(:page).permit(:site_id, :content, :slug, :prompt, :organization_id)
    end

    def inject_chat_partial(content)
      render_to_string(partial: 'shared/llama_bot/chat')
    end

    def inject_style()
      render_to_string(partial: 'shared/llama_bot/css')
    end 

    def inject_analytics_partial()
      render_to_string(partial: 'shared/llama_bot/analytics')
    end
end
