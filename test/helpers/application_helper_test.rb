require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  # Your tests will go here
  test "starts_with_doctype_html? returns true for content starting with <!DOCTYPE html>" do
    assert starts_with_doctype_html?("<!DOCTYPE html><html><head><meta charset='UTF-8'><meta name='viewport' content='width=device-width, initial-scale=1.0'><title>Document</title><script src='tailwind.js'></script><script src='llama.js'></script></head><body><p>Hello, World!</p></body></html>")
  end

  test "starts_with_doctype_html? returns false for content not starting with <!DOCTYPE html>" do
    assert_not starts_with_doctype_html?("<html><head><meta charset='UTF-8'><meta name='viewport' content='width=device-width, initial-scale=1.0'><title>Document</title><script src='tailwind.js'></script><script src='llama.js'></script></head><body><p>Hello, World!</p></body></html>")
  end
end