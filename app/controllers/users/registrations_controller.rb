class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]

  # GET /resource/sign_up
  def new
    super
    # Store prompt in instance variable if it exists in session
    @prompt = session[:prompt]
  end

  # POST /resource
  def create
    super do |user|
      if user.persisted? && params[:prompt].present?
        handle_prompt_after_registration(user, params[:prompt])
        return
      end
    end
  end

  protected

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [
      :email, :password, :password_confirmation,
      organization_attributes: [:name]
    ])
  end

  private

  def handle_prompt_after_registration(user, prompt_text)
    begin
      # Store prompt in session
      session[:prompt] = prompt_text

      # Use the default site created by the organization, or create a new one
      site = user.organization.sites.first || user.organization.sites.create!(
        name: "My AI Website",
        slug: SecureRandom.hex(10)
      )

      # Use the default page created by the organization, or create a new one
      page = site.pages.first || site.pages.create!(
        slug: SecureRandom.hex(4),
        organization: user.organization
      )
      
      # Set as homepage if not already set
      site.update!(home_page_id: page.id) if site.home_page_id.nil?

      # Set as user's default site
      user.update!(default_site_id: site.id)

      chat_message = "can you build me: #{prompt_text}"
      
      # Clear the prompt from session
      session.delete(:prompt)
      
      # Redirect to the page with the chat message
      redirect_with_chat(page_path(page.id), chat_message, { disable_publish_button: true, user_api_token: user.api_token })
    rescue => e
      Rails.logger.error "Error in handle_prompt_after_registration: #{e.message}"
      Rails.logger.error e.backtrace.join("\n")
      
      # If prompt handling fails, redirect to home with notice
      redirect_to root_path, notice: "Welcome! Your account was created successfully."
    end
  end

  # TODO: Pull this out as a helper so other controllers can use it
  def redirect_with_chat(path, message, other_params = {})
    # Store the message in flash instead of URL
    flash[:chat_message] = message
    
    # Keep other params in the URL if they're small
    query_string = other_params.present? ? "?#{other_params.map { |k,v| "#{k}=#{v}" }.join('&')}" : ""
    
    redirect_to "#{path}#{query_string}"
  end
end