class Avo::Resources::StaticSitePage < Avo::BaseResource
  self.includes = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :static_site, as: :belongs_to
    field :content, as: :text
    field :slug, as: :text
    field :prompt, as: :text
  end
end
