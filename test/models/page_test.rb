require "test_helper"

class PageTest < ActiveSupport::TestCase

  def setup
    @organization = organizations(:one)
    @site = sites(:one)
  end

  test 'render_content' do
    page = pages(:one)
    snippet = Snippet.create(content: '<p>Hello, World!</p>', name: 'hello_world', site_id: page.site_id)

    page.content = "<html><head><meta charset='UTF-8'><meta name='viewport' content='width=device-width, initial-scale=1.0'><title>Document</title><script src='tailwind.js'></script><script src='llama.js'></script></head><body>#{snippet.get_snippet_component}</body></html>"
    page.save

    #This seems to be adding in the <!DOCTYPE html>. But when running locally, it's not adding it.

    #Test that it adds the <!DOCTYPE html> and data-llama-ids, data-llama-editable, and data-llama-snippet-id
    assert_equal "<!DOCTYPE html><html><head data-llama-id=\"0\"><meta charset=\"UTF-8\" data-llama-id=\"1\"><meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\" data-llama-id=\"2\"><title data-llama-id=\"3\">Document</title><script src=\"tailwind.js\" data-llama-id=\"4\"></script><script src=\"llama.js\" data-llama-id=\"5\"></script></head><body data-llama-id=\"6\">{{snippet_name: hello_world}}</body></html>", page.content

    #Test that render_content injects the snippet and the llama tags correctly
    rendered_content  = page.render_content

    assert_equal "<!DOCTYPE html><html><head data-llama-id=\"0\" data-llama-editable=\"true\"><meta charset=\"UTF-8\" data-llama-id=\"1\" data-llama-editable=\"true\"><meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\" data-llama-id=\"2\" data-llama-editable=\"true\"><title data-llama-id=\"3\" data-llama-editable=\"true\">Document</title><script src=\"tailwind.js\" data-llama-id=\"4\" data-llama-editable=\"true\"></script><script src=\"llama.js\" data-llama-id=\"5\" data-llama-editable=\"true\"></script></head><body data-llama-id=\"6\" data-llama-editable=\"true\"><p data-llama-snippet-id=\"#{snippet.id}\" data-llama-editable=\"true\">Hello, World!</p></body></html>", rendered_content
  end

  test 'before_save_processing prevents overwriting snippets' do
    page = pages(:one)
    snippet = Snippet.create(content: '<p>Hello, World!</p>', name: 'hello_world', site_id: page.site_id)
    page.content = "<!DOCTYPE html><html><head><meta charset='UTF-8'><meta name='viewport' content='width=device-width, initial-scale=1.0'><title>Document</title><script src='tailwind.js'></script><script src='llama.js'></script></head><body><p data-llama-snippet-id='#{snippet.id}'>Hello, World!</p></body></html>"
    page.save!

    assert page.content.include?(snippet.get_snippet_component)
  end

  test "snippet component renders to html" do   
    page = pages(:one)
    snippet = Snippet.create(content: '<p>Hello, World!</p>', name: 'hello_world', site_id: page.site_id)
    page.content = "<!DOCTYPE html><html><head></head><body>{{snippet_name: hello_world}}</body></html>"
    page.render_snippets(page.content)

    assert_equal "<!DOCTYPE html><html><head></head><body><p data-llama-snippet-id=\"#{snippet.id}\">Hello, World!</p></body></html>", page.content
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

end
