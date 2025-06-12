class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]

  # GET /resource/sign_up
  def new
    super
  end

  # POST /resource
  def create
    super do |user|
      if params[:prompt].present?
        session[:prompt] = params[:prompt]
        return redirect_to create_from_prompt_public_leads_path(prompt: params[:prompt]), method: :post
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
end