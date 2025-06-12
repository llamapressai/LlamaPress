class PublicLeadsController < ApplicationController
  skip_before_action :authenticate_user!
  skip_before_action :verify_authenticity_token, only: [:create_from_prompt_in_wordpress_registration]

  layout 'application'

  def new
    @lead = Lead.new
    # Store prompt in instance variable if it exists in session
    @prompt = session[:prompt]
  end

  def elementor
    @lead = Lead.new
    @prompt = session[:prompt]
    # render layout: 
  end

  # this is for the new picture to HTML upload
  def create
    @lead = Lead.find_by(email: lead_params[:email])
    
    # Create new lead only if it doesn't exist
    if @lead.nil?
      @lead = Lead.new(lead_params)
      return render :new, status: :unprocessable_entity unless @lead.save
    else
      # Update the lead's image if a new one is provided
      @lead.update(image: lead_params[:image]) if lead_params[:image].present?
    end

    # Find existing user or create new one
    user = User.find_by(email: @lead.email)
    
    unless user
      user = User.create!(
        email: @lead.email,
        password: SecureRandom.hex(10),
        organization: Organization.create!(name: @lead.email.split('@').first)
      )
    end
    
    # Sign in the user
    sign_in(user)
    
    # Create a site
    site = current_user.organization.sites.create!(
      name: "My Website",
      slug: "my-website"
    )
      
      # Sign in the user
      sign_in(user)
      
      # Create a site
      site = current_user.organization.sites.create!(
        name: "My Website",
        slug: "my-website"
      )
    # Attach the lead's image to the site's images and get the URL

    # Create a homepage
    @page = site.pages.create!(
      slug: SecureRandom.hex(4),
      organization: current_user.organization
    )

    if @lead.image.present? && @lead.image.attached?
      site.images.attach(@lead.image.blob)
      image_url = @lead.image.blob.service.send(:object_for, @lead.image.key).public_url 
      chat_message = "I am building a #{@lead.notes}, can you please look at this image and clone the look & design of the image: #{image_url}"
    else
      chat_message = "Can you tell me about your capabilities?"
    end
    
    # Set as homepage
    site.update!(home_page_id: @page.id)
    
    # Create initial chat message with image URL
    redirect_with_chat(page_path(@page), chat_message, {disable_publish_button: true})
  end

  def create_from_prompt_in_wordpress_registration
    # begin
      # Store prompt in session
      prompt_text = params[:prompt].to_s
      session[:prompt] = prompt_text

      unless user_signed_in?
        # Try to find existing user
        user = User.find_by(email: params[:email])
        
        if user&.valid_password?(params[:password])
          # Sign in existing user
          sign_in(user)
        else
          # Create new user if sign in failed
          user = User.create!(
            email: params[:email],
            password: params[:password],
            organization: Organization.create!(name: params[:email].split('@').first)
          )
          sign_in(user)
        end
      end

      base64_wordpress_token = params[:credentials]
      decoded_wordpress_token = Base64.decode64(base64_wordpress_token)
      Rails.logger.error("Decoded WordPress Token: #{decoded_wordpress_token}")
      # domain = decoded_wordpress_token[:domain] #TODO: Fix this.

      # Create site for the signed in user
      site = current_user.organization.sites.create!(
        name: "WordPress Site",
        slug: SecureRandom.hex(10),
        wordpress_api_encoded_token: base64_wordpress_token
      )

      @page = site.pages.create!(
        slug: SecureRandom.hex(4),
        organization: current_user.organization
      )
      
      # Set as homepage
      site.update!(home_page_id: @page.id)

      chat_message = "can you build me: #{prompt_text}"

      # if true # Rails.env.production?
      #   Twilio.send_text("9152845787", "WordPress Plugin Registration: #{@lead.email}! prompt: #{prompt_text}, page: https://llamapress.ai/pages/#{@page.id}")
      #   Twilio.send_text("3853001203", "WordPress Plugin Registration: #{@lead.email}! prompt: #{prompt_text}, page: https://llamapress.ai/pages/#{@page.id}")
      #   Twilio.send_text("8019063575", "WordPress Plugin Registration: #{@lead.email}! prompt: #{prompt_text}, page: https://llamapress.ai/pages/#{@page.id}")
      # end
      
      # Clear the prompt from session
      session.delete(:prompt)
      redirect_with_chat(page_path(@page), chat_message, { disable_publish_button: true, user_api_token: user.api_token })
    # rescue ActiveRecord::RecordInvalid => e
    #   flash[:error] = "Could not create account: #{e.message}"
    #   redirect_to new_user_registration_path
    #   Rails.logger.error("Error creating account: #{e.message}")
    # rescue StandardError => e
    #   flash[:error] = "An unexpected error occurred"
    #   Rails.logger.error("Error creating account: #{e.message}")
    #   redirect_to new_user_registration_path
    # end
  end

  def create_from_prompt
      # Store prompt in session
      prompt_text = params[:prompt].to_s
      session[:prompt] = prompt_text

      if !user_signed_in?
        # Try to find existing user
        user = User.find_by(email: params[:email])
        
        if user&.valid_password?(params[:password])
          # Sign in existing user
          sign_in(user)
        else
          # Create new user if sign in failed
          user = User.create!(
            email: params[:email],
            password: params[:password],
            organization: Organization.create!(name: params[:email].split('@').first)
          )
          sign_in(user)
        end
      else 
        user = current_user
      end

      # Create site for the signed in user
      site = current_user.organization.sites.create!(
        name: "My AI Website",
        slug: SecureRandom.hex(10)
      )

      @page = site.pages.create!(
        slug: SecureRandom.hex(4),
        organization: current_user.organization
      )
      # Set as homepage
      site.update!(home_page_id: @page.id)

      chat_message = "can you build me: #{prompt_text}"
      
      # Clear the prompt from session
      session.delete(:prompt)
      redirect_with_chat(page_path(@page), chat_message, { disable_publish_button: true, user_api_token: user.api_token })
  end

  def brand_clone
    @lead = Lead.new
    @prompt = session[:prompt]
  end
  
  def register_and_brand_clone
    # Store prompt in session
    prompt_text = params[:prompt].to_s
    session[:prompt] = prompt_text

    if !user_signed_in?
      # Try to find existing user
      user = User.find_by(email: params[:email])
      
      if user&.valid_password?(params[:password])
        # Sign in existing user
        sign_in(user)
      else
        first_name = params[:full_name]&.split(' ')&.first
        password = "#{SecureRandom.hex(10)}"

        # Create new user if sign in failed
        user = User.create!(
          email: params[:email],
          first_name: first_name,
          last_name: params[:full_name]&.split(' ')&.last,
          phone: params[:phone],
          password: password,
          organization: Organization.create!(name: params[:business_name])
        )
        sign_in(user)
      end
    else 
      user = current_user
    end

    # Create site for the signed in user
    site = current_user.organization.sites.create!(
      name: params[:business_name],
      slug: params[:website_url]
    )

    @page = site.pages.create!(
      slug: "initial-clone-#{params[:business_name]}",
      organization: current_user.organization
    )
    
    # Set as homepage
    site.update!(home_page_id: @page.id)

    chat_message = "please deep clone my site: #{params[:website_url]}"
    
    redirect_with_chat(page_path(@page), chat_message, { disable_publish_button: true, user_api_token: user.api_token })
  end

  def demo
    @lead = Lead.new
    @prompt = session[:prompt]
  end

  private

  #TODO: Pull this out as a helper so other controllers can use it
  def redirect_with_chat(path, message, other_params = {})
    # Store the message in flash instead of URL
    flash[:chat_message] = message
    
    # Keep other params in the URL if they're small
    query_string = other_params.present? ? "?#{other_params.map { |k,v| "#{k}=#{v}" }.join('&')}" : ""
    
    redirect_to "#{path}#{query_string}"
  end

  def lead_params
    params.require(:lead).permit(:email, :image, :notes)
  end

  def upload_to_s3(image)
    return nil unless image.present?

    s3_client = Aws::S3::Client.new(
      region: ENV['AWS_REGION'],
      credentials: Aws::Credentials.new(
        ENV['AWS_KEY'],
        ENV['AWS_PASS']
      )
    )

    filename = image.filename.to_s
    key = "#{SecureRandom.uuid}/#{filename}"
    
    s3_client.put_object(
      bucket: ENV['AWS_BUCKET'],
      key: key,
      body: image.download,
      content_type: image.content_type,
      acl: 'public-read'
    )

    "https://#{ENV['AWS_BUCKET']}.s3.#{ENV['AWS_REGION']}.amazonaws.com/#{key}"
  end
end
