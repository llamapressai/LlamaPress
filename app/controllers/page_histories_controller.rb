class PageHistoriesController < ApplicationController
  before_action :set_page_history, only: %i[ show edit update destroy ]

  # GET /page_histories or /page_histories.json
  def index
    # @page_histories = current_user.organization.page_histories
  end

  # GET /page_histories/1 or /page_histories/1.json
  def show
  end

  # GET /page_histories/new
  def new
    # @page_history = PageHistory.new
  end

  # GET /page_histories/1/edit
  def edit
  end

  # POST /page_histories or /page_histories.json
  def create
    #check page_id belongs to current_user's organization
    # if Page.find(page_history_params[:page_id]).organization != current_user.organization
    #   return redirect_to root_path, notice: "You are not authorized to access this page."
    # end

    @page_history = PageHistory.new(page_history_params)

    respond_to do |format|
      if @page_history.save
        format.html { redirect_to page_history_url(@page_history), notice: "web page history was successfully created." }
        format.json { render :show, status: :created, location: @page_history }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @page_history.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /page_histories/1 or /page_histories/1.json
  def update
    respond_to do |format|
      if @page_history.update(page_history_params)
        format.html { redirect_to page_history_url(@page_history), notice: "web page history was successfully updated." }
        format.json { render :show, status: :ok, location: @page_history }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @page_history.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /page_histories/1 or /page_histories/1.json
  def destroy
    @page_history.destroy!

    respond_to do |format|
      format.html { redirect_to page_histories_url, notice: "web page history was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def list
    @page = Page.find(params[:id])
    @histories = @page.page_histories.order(created_at: :desc)
    
    render json: @histories.map { |history| 
      history.as_json.merge(
        is_current_version: (history.id == @page.current_version_id)
      )
    }
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_page_history
      @page_history = PageHistory.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def page_history_params
      params.require(:page_history).permit(:content, :page_id, :prompt, :user_message)
    end
end
