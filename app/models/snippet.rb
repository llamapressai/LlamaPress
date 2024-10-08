class Snippet < ApplicationRecord
  belongs_to :site
  # Get the syntax needed for the snippet to render on a page.
  def get_snippet_component
    return "{{snippet_name: #{self.name}}}"
  end
end
