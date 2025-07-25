class SubmissionsController < ApplicationController
  before_action :set_submission, only: %i[ show edit update destroy ]
  skip_before_action :verify_authenticity_token, only: [:create, :verify_phone_number_with_twilio, :confirm_verify_code_with_twilio]
  skip_before_action :authenticate_user!, only: [:create, :show, :verify_phone_number_with_twilio, :confirm_verify_code_with_twilio]
  layout false, only: :show

  # GET /submissions or /submissions.json
  def index
    @submissions = []
    current_user.sites.each do |site| 
      @submissions += site.submissions
    end
  end

  # GET /submissions/1 or /submissions/1.json
  def show
  end

  # GET /submissions/new
  def new
  end

  # GET /submissions/1/edit
  def edit
  end

  # POST /submissions/verify_phone_number_with_twilio
  def verify_phone_number_with_twilio
    phone_number = params[:phone_number]
    verification_status = Twilio.send_verification_token(phone_number)
    render json: { status: verification_status }
    # render json: { status: 'success' }
  end

  # POST /submissions/confirm_verify_code_with_twilio
  def confirm_verify_code_with_twilio
    phone_number = params[:phone_number]
    code = params[:code]
    verification_status = Twilio.check_verification_token(phone_number, code)
    render json: { status: verification_status }
  end


  # # POST /submissions/confirm_verify_code_with_twilio
  # def confirm_verify_code_with_twilio
  #   phone_number = params[:phone_number]
  #   code = params[:code]
  #   verification_status = Twilio.check_verification_token(phone_number, code)
  #   render json: { status: verification_status }
  # end

  # POST /submissions or /submissions.json
  def create
    # Spam check - reject if honeypot field is filled
    if params[:hp].present?
      head :ok
      return
    end

    data = JSON.parse(params.to_json).reject { |key, value| 
      ['controller', 'action', 'hp'].include?(key)
    }
    @page = Page.find_by(id: params[:page_id])
    @site = @page&.site || Site.find_by(id: params[:site_id])
    @submission = @site.submissions.new(data: data)

    #TODO: 
    # - What if we don't have page_id set in the form? Do we still record the form submissions?
    # - Is there a way to see where we came from?

    #Below is how to access params in javascript for a customized thank you page:
    #new URLSearchParams(window.location.search).get('name');
    # EXAMPLE:
    #<h1
    # class="text-4xl font-bold mb-2 aos-init aos-animate"
    #   data-aos="fade-down"
    #   data-aos-delay="200"
    #   data-llama-id="14"
    #   data-llama-editable="true">
    #   Thank You
    #   <script data-llama-id="15">
    #     if (new URLSearchParams(window.location.search).get('name')){ 
    #       document.write(`, ${new URLSearchParams(window.location.search).get('name')}`);
    #     }
    #   </script>
    #   !
    # </h1>

    respond_to do |format|
      if @submission.save
        format.html { 
          redirect_to_record = @site.after_submission_page.present? ? @site.after_submission_page : @submission
          redirect_to "#{url_for(redirect_to_record)}?#{data.to_query}",
                     notice: "Submission was successfully created.", allow_other_host: true
        }
        format.json { render :show, status: :created, location: @submission }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @submission.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /submissions/1 or /submissions/1.json
  def update
    respond_to do |format|
      if @submission.update(submission_params)
        format.html { redirect_to submission_url(@submission), notice: "Submission was successfully updated." }
        format.json { render :show, status: :ok, location: @submission }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @submission.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /submissions/1 or /submissions/1.json
  def destroy
    @submission.destroy!

    respond_to do |format|
      format.html { redirect_to submissions_url, notice: "Submission was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_submission
      @submission = Submission.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def submission_params
      params.require(:submission).permit(:data, :site_id)
    end
end
