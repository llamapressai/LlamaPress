class MessageReactionsController < ApplicationController
  before_action :authenticate_user!, optional: true
  before_action :set_page_history, :set_reaction

  # A catch all route for the user clicking thumbs up or thumbs down on a llamabot message. Allows for simpler javascript code
  # POST /message_reactions
  # params: { page_history_id: '123', reaction_type: 'up', feedback: 'This is a test feedback' }
  def handle_reaction
    unless @page_history
      render json: { error: 'Message not found' }, status: :not_found
      return
    end
    
    # Set or toggle reaction type
    if @reaction.new_record? || @reaction.reaction_type != message_reaction_params[:reaction_type]
      @reaction.reaction_type = message_reaction_params[:reaction_type]
      @reaction.feedback = message_reaction_params[:feedback] # Save the feedback text
    else
      # If clicking the same reaction again, remove it
      @reaction.mark_for_destruction
    end
    
    if @reaction.marked_for_destruction?
      @reaction.destroy
      render json: { status: 'reaction_removed' }
    elsif @reaction.save
      render json: { 
        status: 'success', 
        reaction_type: @reaction.reaction_type,
        feedback: @reaction.feedback
      }
    else
      byebug
      Rails.logger.error("Error saving message reaction: #{@reaction.errors.full_messages}")
      render json: { error: @reaction.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def set_page_history
    @page_history = PageHistory.find_by(id: message_reaction_params[:page_history_id])
  end

  def set_reaction
    @reaction = if current_user.present?
      MessageReaction.find_by(
        page_history: @page_history,
        user: current_user
      )
    else
      @page_history.message_reaction
    end
    
    if @reaction.nil?
      @reaction = MessageReaction.new(message_reaction_params)
      @reaction.page_history = @page_history
      @reaction.user = current_user
    end
  end
  
  private

  def message_reaction_params
    params.require(:message_reaction).permit(:reaction_type, :feedback, :page_history_id)
  end
end 