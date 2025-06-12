class SitesController < ApplicationController
  before_action :set_site, only: %i[ show edit update destroy ]
  skip_before_action :verify_authenticity_token, only: [:get_signed_s3_url_for_uploading_images, :create_wordpress_site]
  skip_before_action :authenticate_user!, only: [:create_wordpress_site]
  
  
  # GET /sites or /sites.json
  def index
    @sites = current_organization.sites
  end

  # GET /sites/1 or /sites/1.json
  def show
    @posts = @site.pages.flat_map(&:posts)
  end

  # GET /sites/new
  def new
    @site = current_user.organization.sites.new
  end

  # GET /sites/1/edit
  def edit
  end

  # POST /sites or /sites.json
  def create
    @site = current_user.organization.sites.new(site_params)

    respond_to do |format|
      if @site.save
        format.html { redirect_to site_url(@site), notice: "web site was successfully created." }
        format.json { render :show, status: :created, location: @site }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @site.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sites/1 or /sites/1.json
  def update
    respond_to do |format|
      begin
        if @site.update(site_params)
          format.html { redirect_to site_url(@site), notice: "Web site was successfully updated." }
          format.json { render :show, status: :ok, location: @site }
        else
          format.html { 
            flash.now[:alert] = @site.errors.full_messages.to_sentence
            render :edit, status: :unprocessable_entity 
          }
          format.json { render json: @site.errors, status: :unprocessable_entity }
        end
      rescue ActiveRecord::RecordNotUnique => e
        format.html {
          flash.now[:alert] = "This slug is already taken. Please choose a different one."
          render :edit, status: :unprocessable_entity
        }
        format.json { render json: { error: "Slug already taken" }, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sites/1 or /sites/1.json
  def destroy
    @site.destroy!

    respond_to do |format|
      format.html { redirect_to "/", notice: "web site was successfully destroyed." }
      format.json { head :no_content }
    end
  end


  def attach_pre_uploaded_s3_blob_to_site
    @site = current_site
    Rails.logger.info("Receiving a a request to attach an uploaded s3 file to site")

    if @site.images.attach(params[:signed_id])
      @blob = ActiveStorage::Blob.find_signed(params[:signed_id])
      @attachment = @blob.attachments&.first
      render json: { key: params[:key], image: @site.extract_image_data(@attachment) }, status: 200 
    else
      render json: { error: "error"}, status: 500 
    end
  end 


  def attach_multiple_pre_uploaded_s3_blobs_to_sites
    # params: images: []
    # has_many_attached :images
    
    # imges include blob IDS and attach to this model sites.rb

    if params[:site_slug].present?
      slug = params[:site_slug]
      @page = current_user.organization.pages.find_by(slug: slug) || current_user.organization.pages.find(slug)
      @site = @page.site || current_site
    else
      render json: { error: "No site slug provided" }, status: 400
    end
    
    attached_images = []

    if params[:image_blob_ids].present?
      params[:image_blob_ids].each do |blob_id|
        if blob = ActiveStorage::Blob.find_signed(blob_id)
          @site = @site || current_site
          @site.images.attach(blob.signed_id)
          # Get the most recently attached image
          attached_images << @site.images.last
        end
      end
      
      #Send image data back to the client so we can display them in the UI
      images_json = attached_images.compact.map { |img|
        {
          attachment_id: img.id,
          blob_id: img.blob_id,
          url: img.service.send(:object_for, img.key).public_url,
          image: @site.extract_image_data(img)
        }
      }

      render json: { message: "Images attached to site successfully", images: images_json }, status: 200
    else
      render json: { error: "No image blob IDs provided" }, status: 400
    end
  end
  
  def get_signed_s3_url_for_uploading_images #TODO:! Duplicate code in job_requests_controller
    @blob = ActiveStorage::Blob.create_before_direct_upload!(
      filename: params[:filename],
      byte_size: params[:byte_size],
      checksum: params[:checksum],
      content_type: params[:content_type]
    )

    render json: { url: @blob.service_url_for_direct_upload(expires_in: 30.minutes), headers: @blob.service_headers_for_direct_upload, signed_id: @blob.signed_id, key: @blob.key, blob_url: rails_blob_url(@blob, host: request.base_url)}, status: 200
  end

  def list_images #error -- this keeps getting hit 
    if params[:site_slug].present?
      page = params[:page] || 1
      per_page = 10
      offset = (page.to_i - 1) * per_page
      slug = params[:site_slug]
      @page = current_user.organization.pages.find_by(slug: slug) || current_user.organization.pages.find(slug)
      @site = @page.site || current_site
      @images = @site.images.order(created_at: :desc).offset(offset).limit(per_page)
      json_response = @images.map { |img|
          {
            attachment_id: img.id,
            blob_id: img.blob_id,
            url: img.service.send(:object_for, img.key).public_url,
            image: @site.extract_image_data(img)
          }
      }
      render json: json_response
    else
      render json: { error: "No site slug provided" }, status: 400
    end

  end 

  # POST /api/sites/:slug/wordpress_api_token
  def update_wordpress_token
    required_params = params.permit(:domain, :username, :password, :template_id, :name, :slug, :organization_id)
    missing_params = [:domain, :username, :password, :template_id, :name, :organization_id].select do |key|
      required_params[key].blank?
    end

    if missing_params.any?
      render json: { error: "Missing required parameters: #{missing_params.join(', ')}" }, status: :bad_request
    else
      token_hash = {
        'domain' => required_params[:domain],
        'username' => required_params[:username],
        'password' => required_params[:password],
        'template_id' => required_params[:template_id]
      }
      token_json = token_hash.to_json
      encoded_token = Base64.strict_encode64(token_json)

      site = Site.new(
        name: required_params[:name],
        slug: (required_params[:slug].present? ? required_params[:slug] : required_params[:name].parameterize),
        organization_id: required_params[:organization_id],
        wordpress_api_encoded_token: encoded_token
      )

      if site.save
        render json: { message: 'WordPress API token and site created successfully', site: site }, status: :ok
      else
        render json: { error: 'Failed to create site', details: site.errors.full_messages }, status: :unprocessable_entity
      end
    end
  end

  # POST /api/wordpress_sites
  def create_wordpress_site
    required_params = params.permit(:email, :password, :url, :api_key, :name)
    missing_params = [:email, :password, :url, :api_key, :name].select do |key|
      required_params[key].blank?
    end

    if missing_params.any?
      render json: { error: "Missing required parameters: #{missing_params.join(', ')}" }, status: :bad_request
    else
      # First, validate LlamaPress credentials
      user = User.find_by(email: required_params[:email])
      
      if user && user.valid_password?(required_params[:password])
        begin
          wordpress_credentials = JSON.parse(Base64.decode64(required_params[:api_key]))
          
          # Create a new site with the decoded WordPress credentials
          site = Site.new(
            name: required_params[:name],
            slug: required_params[:name].parameterize,
            wordpress_api_encoded_token: required_params[:api_key],
            organization_id: user.organization_id  # Use the authenticated user's organization
          )

          if site.save
            render json: { 
              message: 'WordPress site created successfully', 
              site: site,
              credentials: {
                email: required_params[:email],
                url: required_params[:url]
              }
            }, status: :ok
          else
            render json: { error: 'Failed to create site', details: site.errors.full_messages }, status: :unprocessable_entity
          end
        rescue JSON::ParserError
          render json: { error: 'Invalid API key format' }, status: :unprocessable_entity
        rescue StandardError => e
          render json: { error: "Unexpected error: #{e.message}" }, status: :internal_server_error
        end
      else
        render json: { error: 'Invalid LlamaPress credentials' }, status: :unauthorized
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_site
      @site = current_user.organization.sites.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def site_params
      params.require(:site).permit(:name, :slug, :organization_id, :wordpress_api_encoded_token, 
                                   :home_page_id, :after_submission_page_id, :system_prompt, :llamabot_agent_name)
    end
end
