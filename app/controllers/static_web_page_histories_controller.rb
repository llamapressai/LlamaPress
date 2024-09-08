class StaticWebPageHistoriesController < ApplicationController
  before_action :set_static_web_page_history, only: %i[ show edit update destroy ]

  # GET /static_web_page_histories or /static_web_page_histories.json
  def index
    @static_web_page_histories = StaticWebPageHistory.all
  end

  # GET /static_web_page_histories/1 or /static_web_page_histories/1.json
  def show
  end

  # GET /static_web_page_histories/new
  def new
    @static_web_page_history = StaticWebPageHistory.new
  end

  # GET /static_web_page_histories/1/edit
  def edit
  end

  # POST /static_web_page_histories or /static_web_page_histories.json
  def create
    @static_web_page_history = StaticWebPageHistory.new(static_web_page_history_params)

    respond_to do |format|
      if @static_web_page_history.save
        format.html { redirect_to static_web_page_history_url(@static_web_page_history), notice: "Static web page history was successfully created." }
        format.json { render :show, status: :created, location: @static_web_page_history }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @static_web_page_history.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /static_web_page_histories/1 or /static_web_page_histories/1.json
  def update
    respond_to do |format|
      if @static_web_page_history.update(static_web_page_history_params)
        format.html { redirect_to static_web_page_history_url(@static_web_page_history), notice: "Static web page history was successfully updated." }
        format.json { render :show, status: :ok, location: @static_web_page_history }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @static_web_page_history.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /static_web_page_histories/1 or /static_web_page_histories/1.json
  def destroy
    @static_web_page_history.destroy!

    respond_to do |format|
      format.html { redirect_to static_web_page_histories_url, notice: "Static web page history was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_static_web_page_history
      @static_web_page_history = StaticWebPageHistory.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def static_web_page_history_params
      params.require(:static_web_page_history).permit(:content, :static_web_page_id, :prompt, :user_message)
    end
end
