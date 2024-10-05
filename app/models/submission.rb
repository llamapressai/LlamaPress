class Submission < ApplicationRecord
  belongs_to :site
  validates :data, presence: true
end
