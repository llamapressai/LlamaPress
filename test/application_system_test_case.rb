require "test_helper"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :selenium, using: :headless_chrome, screen_size: [ 1400, 1400 ]
  
  # driven_by :selenium, using: :chrome, screen_size: [ 1400, 1400 ]
  def pause
    # wait for user to hit enter in terminal
    puts "Press Enter to continue"
    STDIN.gets
  end
end
