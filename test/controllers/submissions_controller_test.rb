require "test_helper"

class SubmissionsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  setup do
    @submission = submissions(:one)
    @site = sites(:one)
    @page = pages(:one)
    @user = users(:one)
    sign_in @user
  end

  # test "should get index" do
  #   get submissions_url
  #   assert_response :success
  # end

  # test "should get new" do
  #   get new_submission_url
  #   assert_response :success
  # end

  test "should create submission" do
    assert_difference("Submission.count") do
      post "/submissions?page_id=#{@page.id}", params: { submission: { data: @submission.data, site_id: @submission.site_id } }
    end

    assert_equal URI.parse(submission_url(Submission.last)).path, URI.parse(response.redirect_url).path
  end

  test "redirection with a after_submission_page" do
    # @site.update(after_submission_page: @page)
    # post "/submissions?page_id=#{@page.id}", params: { submission: { data: @submission.data, site_id: @submission.site_id } }
    # assert_equal URI.parse(submission_url(Submission.last)).path, URI.parse(response.redirect_url).path
  end

  test "should show submission" do
    get submission_url(@submission)
    assert_response :success
  end

  # test "should get edit" do
  #   get edit_submission_url(@submission)
  #   assert_response :success
  # end

  # test "should update submission" do
  #   patch submission_url(@submission), params: { submission: { data: @submission.data, site_id: @submission.site_id } }
  #   assert_redirected_to submission_url(@submission)
  # end

  # test "should destroy submission" do
  #   assert_difference("Submission.count", -1) do
  #     delete submission_url(@submission)
  #   end

  #   assert_redirected_to submissions_url
  # end
end
