class Users::SessionsController < Devise::SessionsController
    skip_before_action :verify_authenticity_token, if: :json_request? #Doing this because it's easier as a one time thing for api authentication and it's an MVP, and it's not part of the public repo.
  
    # POST /resource/sign_in
    def create
        respond_to do |format| #respond to html and json
          format.html {
            super #default devise sign in
          }
          format.json {
              #authentication with api token stretegy, see:  http://blog.plataformatec.com.br/2019/01/custom-authentication-methods-with-devise/
            if params[:api_token]
              self.resource = warden.authenticate!(:api_token_strategy)
            else
              self.resource = warden.authenticate!(auth_options)
            end
            
            sign_in(resource_name, resource)
            user = User.find(resource.id)
            cookies.signed[:user_id] = resource.id
            render :status => 200, :json => { :message => "Success" , userId: user.id,  userEmail: user.email, organizationId: user.organization_id}
          }
        end 
    end

    # GET /resource/sign_in
    # def new
    #   super
    # end
  
    # DELETE /resource/sign_out
    # def destroy
    #   super
    # end
  
    # POST /resource/sign_in
    # def create
    #   super
    # end
  
    # DELETE /resource/sign_out
    # def destroy
    #   super
    # end
  
    # protected
  
    # If you have extra params to permit, append them to the sanitizer.
    # def configure_sign_in_params
    #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
    # end

    private

    def json_request?
        request.format.json?
    end
  end
