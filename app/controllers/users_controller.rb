class UsersController < ApplicationController
  before_action :set_user, only: %i[ show edit update destroy ]

  # GET /users or /users.json
  def index
    @users = current_organization.users.all
  end

  # GET /users/1 or /users/1.json
  def show
    respond_to do |format|
      format.html # This will render the default show.html.erb template
      format.json { render json: @user.to_json }
    end
  end

  # GET /users/new
  def new
    @user = current_organization.users.new
    @user.build_organization
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users or /users.json
  def create
    @user = current_organization.users.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to user_url(@user), notice: "User was successfully created." }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    @user = current_organization.users.find(params[:id])
    respond_to do |format|
      if @user.update(user_params)
        format.html do
          if request.referrer&.include?('default_site') # Allow user to update their default site easily with floating user menu
            redirect_back(fallback_location: root_path, notice: 'Default site updated.')
          else
            redirect_to @user, notice: 'User was successfully updated.'
          end
        end
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1 or /users/1.json
  def destroy
    @user.destroy!

    respond_to do |format|
      format.html { redirect_to users_url, notice: "User was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  # PUT /users/set_tutorial_step
  def set_tutorial_step
    if params[:tutorial_step].present? && current_user.present?
      current_user.tutorial_step = params[:tutorial_step]
      current_user.save!
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = current_organization.users.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:email, :phone, :first_name, :last_name, :organization_id, :default_site_id, :password, :password_confirmation)
    end
end
