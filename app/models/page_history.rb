class PageHistory < ApplicationRecord
  belongs_to :page

  def is_current_version?
    page&.current_version_id == id
  end
end
