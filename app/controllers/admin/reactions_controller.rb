class Admin::ReactionsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_admin
  
  def index
    @reactions = MessageReaction.includes(:chat_message, :user)
                               .order(created_at: :desc)
                               .page(params[:page]).per(50)
  end
  
  private
  
  def ensure_admin
    redirect_to root_path, alert: "Not authorized" unless current_user.admin?
  end
end 