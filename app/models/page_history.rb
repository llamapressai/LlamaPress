class PageHistory < ApplicationRecord
  belongs_to :page
  has_one :message_reaction, dependent: :nullify

  def is_current_version?
    page&.current_version_id == id
  end
end