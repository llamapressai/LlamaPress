# Api::V1::ApplicationController is in the starter repository and isn't
# needed for this package's unit tests, but our CI tests will try to load this
# class because eager loading is set to `true` when CI=true.
# We wrap this class in an `if` statement to circumvent this issue.
if defined?(Api::V1::ApplicationController)
  class Api::V1::StaticSitesController < Api::V1::ApplicationController
    account_load_and_authorize_resource :static_site, through: :team, through_association: :static_sites

    # GET /api/v1/teams/:team_id/static_sites
    def index
    end

    # GET /api/v1/static_sites/:id
    def show
    end

    # POST /api/v1/teams/:team_id/static_sites
    def create
      if @static_site.save
        render :show, status: :created, location: [:api, :v1, @static_site]
      else
        render json: @static_site.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /api/v1/static_sites/:id
    def update
      if @static_site.update(static_site_params)
        render :show
      else
        render json: @static_site.errors, status: :unprocessable_entity
      end
    end

    # DELETE /api/v1/static_sites/:id
    def destroy
      @static_site.destroy
    end

    private

    module StrongParameters
      # Only allow a list of trusted parameters through.
      def static_site_params
        strong_params = params.require(:static_site).permit(
          *permitted_fields,
          :name,
          :slug,
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
  class Api::V1::StaticSitesController
  end
end
