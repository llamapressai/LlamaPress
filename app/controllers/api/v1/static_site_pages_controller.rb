# Api::V1::ApplicationController is in the starter repository and isn't
# needed for this package's unit tests, but our CI tests will try to load this
# class because eager loading is set to `true` when CI=true.
# We wrap this class in an `if` statement to circumvent this issue.
if defined?(Api::V1::ApplicationController)
  class Api::V1::StaticSitePagesController < Api::V1::ApplicationController
    account_load_and_authorize_resource :static_site_page, through: :static_site, through_association: :static_site_pages

    # GET /api/v1/static_sites/:static_site_id/static_site_pages
    def index
    end

    # GET /api/v1/static_site_pages/:id
    def show
    end

    # POST /api/v1/static_sites/:static_site_id/static_site_pages
    def create
      if @static_site_page.save
        render :show, status: :created, location: [:api, :v1, @static_site_page]
      else
        render json: @static_site_page.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /api/v1/static_site_pages/:id
    def update
      if @static_site_page.update(static_site_page_params)
        render :show
      else
        render json: @static_site_page.errors, status: :unprocessable_entity
      end
    end

    # DELETE /api/v1/static_site_pages/:id
    def destroy
      @static_site_page.destroy
    end

    private

    module StrongParameters
      # Only allow a list of trusted parameters through.
      def static_site_page_params
        strong_params = params.require(:static_site_page).permit(
          *permitted_fields,
          :content,
          :slug,
          :prompt,
          # 🚅 super scaffolding will insert new fields above this line.
          *permitted_arrays,
          # 🚅 super scaffolding will insert new arrays above this line.
        )

        process_params(strong_params)

        strong_params
      end
    end

    include StrongParameters
  end
else
  class Api::V1::StaticSitePagesController
  end
end
