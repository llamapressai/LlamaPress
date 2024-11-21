require "test_helper"

#https://justin.searls.co/posts/running-rails-system-tests-with-playwright-instead-of-selenium/
Capybara.register_driver :my_playwright do |app| 
  Capybara::Playwright::Driver.new(app,
    browser_type: ENV["PLAYWRIGHT_BROWSER"]&.to_sym || :chromium,
    headless: (true unless ENV["CI"] || ENV["PLAYWRIGHT_HEADLESS"]))
#    headless: (false unless ENV["CI"] || ENV["PLAYWRIGHT_HEADLESS"]))

end

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :my_playwright #https://justin.searls.co/posts/running-rails-system-tests-with-playwright-instead-of-selenium/

  # driven_by :selenium, using: :chrome, screen_size: [ 1400, 1400 ]
  def pause
    # wait for user to hit enter in terminal
    puts "Press Enter to continue"
    STDIN.gets
  end
end
