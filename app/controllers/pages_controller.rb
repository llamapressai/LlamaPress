require 'diffy'
require 'builder'

class PagesController < ApplicationController
  before_action :set_page, only: %i[ show edit update destroy restore preview]
  skip_before_action :authenticate_user!, only: [:home, :resolve_slug, :show, :sitemap_xml, :robots_txt]
  skip_before_action :verify_authenticity_token, only: [:restore, :update]

  # GET /
  # Find and render the root page depending on the domain.
  # If no root page is found, redirect to the llama press home
  def home
    #If the user is signed in, and they have a default site, redirect to that site's home page.
    #If no user, no site, no page, no domain.
    # Found a signed in user -- let's take them to their home page.
    if current_user.present? #current_site.present? && current_site.slug != 'llamapress.ai' #current_site is set in application_controller.rb, based on domain that's requesting.
      Rails.logger.info "Current User Found! #{current_user.email}"
      if current_user.needs_tutorial? # routing for the tutorial steps depending on what step they're on.
        redirect_to current_user.tutorial_step_path and return
      else 
        redirect_to llama_bot_home_path and return
      end
    else # if it's a non-signed in user, check the domain and serve them the home page for that domain.
      Rails.logger.info "Non-User came to website #{request.domain} with route #{request.path}. Checking to see if we have a site that matches this domain now. Checking if we have a site with this domain already..."
      Rails.logger.info "Site that was matched: #{current_site&.slug}" # this gets set in application_controller.rb
      
      # They came to a domain that has a site associated with it. (Excluding llamapress.ai)
      if current_site.present? && current_site.slug != ENV["HOSTED_DOMAIN"]
        Rails.logger.info "Found site #{current_site.slug} for domain #{request.domain}. Taking them to the home page for this site now"
        @page = current_site.home_page || current_site.pages.first # try to get home page if it's set, otherwise just get the first page.
        if @page.nil?
          Rails.logger.info 'no page in site, taking them to llamapress home page'
          redirect_to llama_bot_home_path and return
        else
          #pass through and render everything for a public visitor to this site.
        end
      end
    end

    if current_site.nil? || @page.nil? #what should we do if current_site is nil, and there's no page?
      Rails.logger.info 'no site found, taking them to llamapress home page'
      redirect_to "/users/sign_up" and return
    end

    Rails.logger.info 'rendering page to a non-signed in user -- this is likely a public traffic visit going to a site\'s home page'
    content = @page.render_content # we know @page is present, because we redirected above if it wasn't.
    #content += inject_chat_partial(content) if current_user.present?
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
   @pages = current_organization.pages

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
    if current_user.present? && @page.organization_id == current_user.organization_id
      # Inject the chat partial
      content += inject_chat_partial(content)
      content += inject_analytics_partial() if Rails.env.production?
    end
    render inline: content.html_safe, layout: 'page'
  end

  # GET /pages/new
  def new
    @page = current_organization.pages.build
    @site_id = params[:site_id].present? ? params[:site_id] : current_site.id
    @templates = PagesHelper.get_starting_templates # get html content from each file in templates folder
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
        format.html { redirect_to page_url(@page.id), notice: "web page was successfully created." }
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
        format.html { redirect_to page_url(@page.id), notice: "web page was successfully updated." }
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
    @page_number = params[:page] || 1
    @per_page = 10
    
    @page_histories = @page.page_histories
      .order(created_at: :desc)
      .page(@page_number)
      .per(@per_page)
    
    respond_to do |format|
      format.html
      format.json do
        encoded_histories = @page_histories.map do |history|
          history_data = history.as_json
          history_data['content'] = Base64.strict_encode64(history.content)
          history_data
        end
        render json: {
          web_page_histories: encoded_histories,
          meta: {
            current_page: @page_histories.current_page,
            total_pages: @page_histories.total_pages,
            total_count: @page_histories.total_count,
            per_page: @per_page
          }
        }
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

  def sitemap_xml
    @pages = current_site.pages
    
    # Build XML using Builder
    xml = Builder::XmlMarkup.new(indent: 2)
    xml.instruct!

    # Create urlset with necessary namespaces
    xml.urlset(
      'xmlns' => 'http://www.sitemaps.org/schemas/sitemap/0.9',
      'xmlns:image' => 'http://www.google.com/schemas/sitemap-image/1.1',
      'xmlns:news' => 'http://www.google.com/schemas/sitemap-news/0.9',
      'xmlns:video' => 'http://www.google.com/schemas/sitemap-video/1.1'
    ) do
      # Add home page as highest priority
      xml.url do
        xml.loc("https://" + current_site.slug)
        xml.lastmod(Time.current.strftime('%Y-%m-%d'))
        xml.changefreq('daily')
        xml.priority(1.0)
      end

      # Add each page
      @pages.each do |page|
        xml.url do
          xml.loc("https://" + current_site.slug + "/" + page.slug)
          xml.lastmod(page.updated_at.strftime('%Y-%m-%d'))
          xml.changefreq('weekly')
          xml.priority(0.8)

          # If page has attached images, add them
          if page.respond_to?(:images) && page.images.attached?
            page.images.each do |image|
              xml.image :image do
                xml.image :loc, url_for(image)
                xml.image :title, image.filename.to_s
                xml.image :caption, "Image for #{page.slug}"
              end
            end
          end
        end
      end
    end

    # Render XML with proper content type
    render xml: xml.target!, content_type: 'application/xml'
  end

  def robots_txt
    render plain: "User-agent: *\nAllow: /"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_page
      @page = Page.friendly.find(params[:id]) || Page.find(params[:id])
      # @page = current_user.organization.pages.friendly.find(params[:id]) || Page.find(params[:id])
    end

    def set_site
      if page_params[:site_id].present?
        @site = Site.find(params[:site_id])
        # @site = current_user.sites.find(params[:site_id])
      else
        @site = current_site || @page.site || current_organization.sites.first
        # @site = current_site || @page.site || current_user.sites.first
      end
    end

    # Only allow a list of trusted parameters through.
    def page_params
      params.require(:page).permit(:site_id, :content, :slug, :organization_id)
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
