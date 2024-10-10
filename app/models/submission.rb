class Submission < ApplicationRecord
  require 'twilio'
  belongs_to :site
  validates :data, presence: true
  after_create :notify_submission

  def notify_submission
    try do
      page_for_submission = Page.find(self.data['page_id'])
      Twilio.send_text('9152845787', "New Submission: #{self.data}. Page: #{page_for_submission&.slug}")
    rescue => e
      puts "Error: #{e.message}"
      Twilio.send_text('9152845787', "New Submission: #{self.data}. Error: #{e.message}")
    end
  end
end