require 'diffy'
require 'builder'
require 'nokogiri'

class PagesController < ApplicationController
  include LlamaBotRails::ControllerExtensions
  include LlamaBotRails::AgentAuth
  
  # ─── Allow the agent to hit these actions ────────────────────────────────
  llama_bot_allow :update #, :show, :preview, :restore

  before_action :set_page, only: %i[ show edit update destroy restore preview page_redo page_undo download_html ]
  skip_before_action :authenticate_user!, only: [:home, :resolve_slug, :show, :sitemap_xml, :robots_txt] #temporarily allowing update for local dev testing.
  skip_before_action :verify_authenticity_token #, only: [:restore, :update]

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
    Rails.logger.info "Resolving slug for path: #{params[:path]}"
    Rails.logger.info "Current site: #{current_site&.slug}"
  
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
    
    if (current_user&.organization_id == @page.organization_id) || 
       (params[:user_api_token].present? && User.find_by(api_token: params[:user_api_token])&.tap { |u| sign_in(u) })
      
      begin
        # Try to find </body> tag position
        body_end_index = content.rindex('</body>')
        
        if body_end_index
          # Insert our content just before </body>
          injected_content = inject_chat_partial(content)
          injected_content += inject_analytics_partial if Rails.env.production?
          
          content = content.insert(body_end_index, injected_content)
        else
          # Fallback: If no </body> tag found, append at the end
          Rails.logger.warn "No </body> tag found in page content, appending content at the end"
          content += inject_chat_partial(content)
          content += inject_analytics_partial if Rails.env.production?
        end
      rescue => e
        Rails.logger.error "Error injecting content: #{e.message}"
        # Fallback to simple append
        content += inject_chat_partial(content)
        content += inject_analytics_partial if Rails.env.production?
      end
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
    # byebug
    message = params[:message].present? ? params[:message] : "User Edit"
    Rails.logger.info "Attempting to update page #{@page.id} with message: #{message}"
    
    respond_to do |format|
      if @page.update(page_params)
        Rails.logger.info "Successfully updated page #{@page.id}"
        @page.save_history(message)
        Rails.logger.info "Saved page history with message: #{message}"
        
        format.html { redirect_to page_url(@page.id), notice: "web page was successfully updated." }
        format.json { render :show, status: :ok, location: @page }
      else
        Rails.logger.error "Failed to update page #{@page.id}. Errors: #{@page.errors.full_messages}"
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

  # GET /pages/1/histories
  # Returns a paginated list of page histories and chat messages for a given page.
  # The histories are combined and sorted by creation date, with the most recent items first.
  # The response is paginated, with a default of 10 items per page.
  # The current page number is optional, and defaults to 1.
  # The response is formatted as JSON, with the following structure:
  
  def histories
    @page = Page.find(params[:id])
    @page_number = params[:page] || 1
    @per_page = 1000
    
    # Get both page histories and chat messages
    @page_histories = @page.page_histories

    @message_history = nil
    if !Rails.env.test? #depends on localhost:8000 running with LlamaBot with this route in FastAPI
      @llamabot_state_history = LlamaBot.get_message_history_from_llamabot_checkpoint(@page.id)
      @message_history = @llamabot_state_history["messages"]
    end  

    # Use page histories and llamabot state history (no more chat messages)
    @combined_history = @message_history.nil? ? @page_histories : @message_history
    
    # Manual pagination
    # start_index = (@page_number.to_i - 1) * @per_page
    # @paginated_items = @combined_history[start_index, @per_page]
  total_items = @combined_history.length
    
    respond_to do |format|
      format.html
      format.json do
        encoded_items = @combined_history.map do |item|
          if item.is_a?(PageHistory)
            item.as_json.merge({
              type: 'page_history',
              content: Base64.strict_encode64(item.content),
            })
          else # LlamaBot message
            content = item["content"]
            #bot and user magic strings are used in the javascript client to determine which color & style to use for the message.
            # role = item["type"] == "ai" ? "bot" : item["type"] == "user" ? "user" : item["type"] == "system" ? "system" : item["type"] == "tool" ? "tool" : "user"
            if item["type"] == "human"
              role = "user"
            elsif item["type"] == "ai"
              if item["content"].blank? && item["additional_kwargs"].to_s.include?("tool_call")
                # byebug
                content = "🧠: " + (item["additional_kwargs"]["tool_calls"][0]["function"]["name"]&.titleize) + " called with arguments: " + item["additional_kwargs"]["tool_calls"][0]["function"]["arguments"]
                role = "tool"
              else  
                role = "bot"
              end
            elsif item["type"] == "tool"
              content = "⚙️: " + item["content"]
              role = "tool"
            else
              role = "user"
            end

            {
              type: 'chat_message',
              id: item["id"],
              #created_at: item.created_at,
              content: content,
              role: role 
            }
          end
        end
        
        render json: {
          history_items: encoded_items,
          meta: {
            current_page: @page_number.to_i,
            total_pages: (total_items.to_f / @per_page).ceil,
            total_count: total_items,
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
  
  # POST /pages/1/publish_to_wordpress
  def publish_to_wordpress
    @page = current_organization.pages.find(params[:id])
    begin
      @page.publish_to_wordpress!
    rescue => e
      render json: { message: "Error publishing to WordPress: #{e.message}" }, 
             status: :unprocessable_entity
      return
    end
    render json: { message: "Web page was successfully published to WordPress." }, 
           status: :ok
  end

  def restore_with_history
    @page = Page.friendly.find(params[:id])
    @page_history = PageHistory.find(params[:page_history_id])
    
    if @page.restore_with_history(@page_history, "Restored by user")
      respond_to do |format|
        format.json { render json: { success: true, message: 'Page restored successfully' } }
      end
    else
      respond_to do |format|
        format.json { render json: { success: false, error: 'Failed to restore page' }, status: :unprocessable_entity }
      end
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

  def page_undo
    success = @page.undo
    
    respond_to do |format|
      if success
        format.html { redirect_to @page, notice: 'Successfully undid last change.' }
        format.json { render json: { message: 'Successfully undid last change', page: @page }, status: :ok }
      else
        format.html { redirect_to @page, alert: 'No more changes to undo.' }
        format.json { render json: { error: 'No more changes to undo' }, status: :unprocessable_entity }
      end
    end
  end

  def page_redo
    success = @page.redo
    
    respond_to do |format|
      if success
        format.html { redirect_to @page, notice: 'Successfully redid last change.' }
        format.json { render json: { message: 'Successfully redid last change', page: @page }, status: :ok }
      else
        format.html { redirect_to @page, alert: 'No more changes to redo.' }
        format.json { render json: { error: 'No more changes to redo' }, status: :unprocessable_entity }
      end
    end
  end

  def twilio_verify_example
    render layout: false
  end

  def download_html
    begin
      content = @page.render_content
      
      send_data content, 
                filename: "llamapress-ai-#{@page.slug}.html", 
                type: "text/html",
                disposition: 'attachment'
    rescue => e
      Rails.logger.error "Download failed: #{e.message}"
      Rails.logger.error e.backtrace.join("\n")
      
      redirect_to @page, alert: "Download failed: #{e.message}"
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_page
    @page = Page.friendly.find(params[:id]) || Page.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      respond_to do |format|
        format.html { redirect_to pages_path, alert: 'Page not found.' }
        format.json { render json: { error: 'Page not found' }, status: :not_found }
      end
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
      params.require(:page).permit(:site_id, :content, :slug, :organization_id, :wordpress_page_id)
    end

    def inject_chat_partial(content)
      @chat_channel_session_id = get_session_id_for_websocket_chat_channel()
      render_to_string(partial: 'shared/llama_bot/chat')
    end

    def inject_style()
      render_to_string(partial: 'shared/llama_bot/css')
    end 

    def inject_analytics_partial()
      render_to_string(partial: 'shared/llama_bot/analytics')
    end

    def get_session_id_for_websocket_chat_channel()
      if Rails.env.test?
        return "test_session_123" #for testing purposes, we need to return a predictable session id. See chat_frontend_llamabot_test.rb for more details.
      else
        return session.id
      end
    end
end