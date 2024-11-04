require 'test_helper'

class SubmissionTest < ActiveSupport::TestCase
  def setup
    @site = sites(:one)  # Assuming you have a site fixture
    @page = pages(:one)  # Assuming you have a page fixture
    @user = users(:one)  # Assuming you have a user fixture
    
    # Create a basic submission
    @submission = Submission.new(
      site: @site,
      data: { 'page_id' => @page.id }
    )
  end

  test "notify_submission sends texts successfully" do
    # Setup: Configure user with phone
    @page.organization.users = [@user]
    @user.update(phone: '1234567890')

    # Stub Twilio calls
    Twilio.expects(:send_text).with('9152845787', "New Submission: #{@submission.data}. Page: #{@page.slug}").once
    Twilio.expects(:send_text).with(@user.phone, "New Submission: #{@submission.data}. Page: #{@page.slug}").once

    @submission.save
  end

  test "notify_submission handles missing user phone" do
    # Setup: Configure user without phone
    @page.organization.users = [@user]
    @user.update(phone: nil)

    # Should only send one text (to admin number)
    Twilio.expects(:send_text).with('9152845787', "New Submission: #{@submission.data}. Page: #{@page.slug}").once
    
    @submission.save
  end

  test "notify_submission handles errors" do
    # Setup: Force an error by making page_id invalid
    @submission.data = { 'page_id' => 99999 }

    # Should send error notification
    Twilio.expects(:send_text).with('9152845787', "New Submission: #{@submission.data}. Error: Couldn't find Page with 'id'=99999").once
    
    @submission.save
  end
end
