# frozen_string_literal: true
$LOAD_PATH << "../lib"

RSpec.configure do |config|
  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
end

def fixture_path(path)
  File.join(File.dirname(__FILE__), "fixtures", path)
end
