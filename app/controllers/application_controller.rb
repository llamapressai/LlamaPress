class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  before_action :authenticate_user!, :set_context

  def current_organization
    current_user.try :organization
  end

  def current_site
    # Number One: Check Request Info for Domain.
    if ENV["OVERRIDE_DOMAIN"].present? #This is used for development, use OVERRIDE_DOMAIN to test different sites
      domain = ENV["OVERRIDE_DOMAIN"]
    else
      domain = sanitize_domain(request.env["HTTP_HOST"].dup)
    end

    @site = Site.find_by(slug: domain)

    if @site.nil?
      #Number Two: Inspect the params for a page_id, or site_id.
      if params[:site_id].present?
        @site = Site.find_by(id: params[:site_id])
      elsif params[:page_id].present?
        @page = Page.find_by(id: params[:page_id])
        @site = @page.site
      end
    end

    if @site.nil?
      #Number Three: Inspect the current_user for their default site.
      @site = current_user&.try :site
    end

    if @site.nil?
      #Number Four: Inspect the current_organization for their default site.
      @site = current_user&.default_site
    end

    if @site.nil?
      #Number Five: Inspect the current_organization for their default site.
      @site = current_user&.organization&.sites&.first
    end

    # If no user, no site, no page, no domain, then current_site is nil.
    Rails.logger.info("Domain request for: " + domain)
    return @site
  end

  def set_context
    @context = request.path
    @view_path = resolve_view_path #this is used for LlamaBot to know what file to write code changes to.
  end

  private
  # This is used to get the corresponding view file based on the controller route and action, so that LlamaBot can write 
  # any code changes to the correct views file in the user's file system.
  def resolve_view_path
    route = Rails.application.routes.recognize_path(request.path, method: request.method)
    controller = route[:controller]
    action = route[:action]

    # Check if there's a specific route helper for this path
    route_helper = Rails.application.routes.named_routes.helper_names.find do |helper|
      path = send("#{helper}_path") rescue nil
      path == request.path
    end

    if route_helper
      # If a route helper is found, use it to determine the view
      controller, action = route_helper.to_s.sub(/_path$/, '').split('_', 2)
    end

    "app/views/#{controller}/#{action}.html.erb"
  rescue ActionController::RoutingError
    nil
  end

  # This is used to sanitize the domain to match the slug format of the site.
  # To allow LlamaPress to properly route to the site, the domain must be saved to the user's Site record in the slug column, and not have a www., http://, or https://.
  # The user must also have an A record in their DNS settings pointing to the IP address of the LlamaPress server.
  # and the site must have a security certificate configured for the domain. 
  def sanitize_domain(domain)
    domain.slice! "www."
    domain.slice! "http://"
    domain.slice! "https://"
    domain
  end
end
