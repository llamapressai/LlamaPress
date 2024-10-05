require "application_system_test_case"

class SnippetsTest < ApplicationSystemTestCase
  setup do
    @snippet = snippets(:one)
  end

  test "visiting the index" do
    visit snippets_url
    assert_selector "h1", text: "Snippets"
  end

  test "should create snippet" do
    visit snippets_url
    click_on "New snippet"

    fill_in "Content", with: @snippet.content
    fill_in "Name", with: @snippet.name
    fill_in "Site", with: @snippet.site_id
    click_on "Create Snippet"

    assert_text "Snippet was successfully created"
    click_on "Back"
  end

  test "should update Snippet" do
    visit snippet_url(@snippet)
    click_on "Edit this snippet", match: :first

    fill_in "Content", with: @snippet.content
    fill_in "Name", with: @snippet.name
    fill_in "Site", with: @snippet.site_id
    click_on "Update Snippet"

    assert_text "Snippet was successfully updated"
    click_on "Back"
  end

  test "should destroy Snippet" do
    visit snippet_url(@snippet)
    click_on "Destroy this snippet", match: :first

    assert_text "Snippet was successfully destroyed"
  end
end
