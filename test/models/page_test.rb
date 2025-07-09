require "test_helper"

class PageTest < ActiveSupport::TestCase

  def setup
    @organization = organizations(:one)
    @site = sites(:one)
  end

  test 'render_content adds llama tags correctly' do
    page = pages(:one)
    page.content = "<html><head><meta charset='UTF-8'><meta name='viewport' content='width=device-width, initial-scale=1.0'><title>Document</title><script src='tailwind.js'></script><script src='llama.js'></script></head><body><p>Hello, World!</p></body></html>"
    page.save

    #Test that render_content adds the llama tags correctly
    rendered_content = page.render_content

    assert rendered_content.include?('data-llama-editable="true"')
    assert rendered_content.include?('data-llama-id=')
  end

  test 'before_save_processing adds llama ids to content' do
    page = pages(:one)
    page.update(content: "<!DOCTYPE html><html><head><meta charset='UTF-8'><meta name='viewport' content='width=device-width, initial-scale=1.0'><title>Document</title><script src='tailwind.js'></script><script src='llama.js'></script></head><body><p>Hello, World!</p></body></html>")
    assert_equal "<!DOCTYPE html><html><head data-llama-id=\"0\"><meta charset=\"UTF-8\" data-llama-id=\"1\"><meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\" data-llama-id=\"2\"><title data-llama-id=\"3\">Document</title><script src=\"tailwind.js\" data-llama-id=\"4\"></script><script src=\"llama.js\" data-llama-id=\"5\"></script></head><body data-llama-id=\"6\"><p data-llama-id=\"7\">Hello, World!</p></body></html>", page.content
  end

  test "before_save ensures doctype html" do
    page = pages(:one)
    page.content = "<html><head><meta charset='UTF-8'><meta name='viewport' content='width=device-width, initial-scale=1.0'><title>Document</title><script src='tailwind.js'></script><script src='llama.js'></script></head><body><p>Hello, World!</p></body></html>"
    page.ensure_doctype_html!
    assert_equal "<!DOCTYPE html><html><head><meta charset=\"UTF-8\"><meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\"><title>Document</title><script src=\"tailwind.js\"></script><script src=\"llama.js\"></script></head><body><p>Hello, World!</p></body></html>", page.content
  end

  test "creates a unique slug when a duplicate exists" do
    # Create an initial page with a slug
    original_page = Page.create!(site: @site, slug: 'test-slug', organization: @organization)

    # Create a new page with the same initial slug
    new_page = Page.create!(site: @site, slug: 'test-slug', organization: @organization)

    # Assert the new page has a unique slug
    assert_equal 'test-slug-1', new_page.slug

    # Create another page with the same initial slug
    third_page = Page.create!(site: @site, slug: 'test-slug', organization: @organization)

    # Assert the third page has a unique slug
    assert_equal 'test-slug-2', third_page.slug
  end

  test "make_unique_slug does not modify the slug if it is already unique" do
    # Create a page with a unique slug
    unique_page = Page.new(site: @site, slug: 'unique-slug')
    unique_page.send(:make_unique_slug)

    # Assert the slug remains unchanged
    assert_equal 'unique-slug', unique_page.slug
  end

  test "save_initial_history creates initial page history" do
    page = Page.create(site: @site, slug: 'test-slug', organization: @organization)
    assert_equal 1, page.page_histories.count
    assert_equal "Initial Save", page.page_histories.first.user_message
  end
end
