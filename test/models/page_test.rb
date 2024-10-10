require "test_helper"

class PageTest < ActiveSupport::TestCase

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
end