class Admin::HomeController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_admin
  
  def index
    # Get key metrics for the admin dashboard
    @total_users = User.count
    @total_conversations = ChatConversation.count
    @total_messages = ChatMessage.count
    
    # Recent activity
    @recent_users = User.order(created_at: :desc).limit(5)
    @recent_messages = ChatMessage.includes(:user, :chat_conversation)
                                .order(created_at: :desc)
                                .limit(10)
    
    # Subscription metrics
    @subscribed_users = User.where.not(stripe_subscription_id: nil).count
    
    # Message statistics
    @messages_today = ChatMessage.where('created_at >= ?', Time.current.beginning_of_day).count
    @messages_this_week = ChatMessage.where('created_at >= ?', Time.current.beginning_of_week).count
    
    # User engagement
    @active_users_today = ChatMessage.where('created_at >= ?', Time.current.beginning_of_day)
                                   .distinct.count(:user_id)
  end

  def view_image_uploads
    @images = ActiveStorage::Attachment
      .where(record_type: 'Site', name: 'images')
      .order(created_at: :desc)
      .page(params[:page])
      .per(200)
  end

  private

  def ensure_admin
    redirect_to root_path, alert: "Not authorized" unless current_user.admin?
  end
end 