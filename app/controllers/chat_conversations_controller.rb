class ChatConversationsController < ApplicationController
  before_action :set_chat_conversation, only: %i[ show edit update destroy ]

  # GET /chat_conversations or /chat_conversations.json
  def index
    @chat_conversations = current_user.chat_conversations.all
  end

  # GET /chat_conversations/1 or /chat_conversations/1.json
  def show
  end

  # GET /chat_conversations/new
  def new
    @chat_conversation = ChatConversation.new
  end

  # GET /chat_conversations/1/edit
  def edit
  end

  # POST /chat_conversations or /chat_conversations.json
  def create
    @chat_conversation = ChatConversation.new(chat_conversation_params)

    respond_to do |format|
      if @chat_conversation.save
        format.html { redirect_to chat_conversation_url(@chat_conversation), notice: "Chat conversation was successfully created." }
        format.json { render :show, status: :created, location: @chat_conversation }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @chat_conversation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /chat_conversations/1 or /chat_conversations/1.json
  def update
    respond_to do |format|
      if @chat_conversation.update(chat_conversation_params)
        format.html { redirect_to chat_conversation_url(@chat_conversation), notice: "Chat conversation was successfully updated." }
        format.json { render :show, status: :ok, location: @chat_conversation }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @chat_conversation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /chat_conversations/1 or /chat_conversations/1.json
  def destroy
    @chat_conversation.destroy!

    respond_to do |format|
      format.html { redirect_to chat_conversations_url, notice: "Chat conversation was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_chat_conversation
      @chat_conversation = ChatConversation.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def chat_conversation_params
      params.require(:chat_conversation).permit(:title, :user_id, :site_id, :page_id, :uuid)
    end
end
