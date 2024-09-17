class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  before_action :authenticate_user!, :set_context

  def current_organization
    current_user.try :organization
  end

  def current_site
    domain = request.env["HTTP_HOST"].dup
    domain.slice! "www."
    Rails.logger.info("Domain request for: " + domain)

    StaticWebSite.find_by(slug: domain)
  end

  def set_context
    @context = request.path
    @view_path = resolve_view_path
  end

  private

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
end
