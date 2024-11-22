class Submission < ApplicationRecord
  require 'twilio'
  belongs_to :site
  validates :data, presence: true
  after_create :notify_submission

  def notify_submission
    if Rails.env.production?
      try do
        page_for_submission = Page.find(self.data['page_id'])
        Twilio.send_text('9152845787', "New Submission: #{self.data}. Page: #{page_for_submission&.slug}")
        # find the user who owns the page
        user = page_for_submission.organization&.users&.first
        if user&.phone&.present?
          Twilio.send_text(user.phone, "New Submission: #{self.data}. Page: #{page_for_submission&.slug}")
        end
      rescue => e
        puts "Error: #{e.message}"
        Twilio.send_text('9152845787', "New Submission: #{self.data}. Error: #{e.message}")
      end
    end
  end
end