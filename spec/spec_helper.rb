# frozen_string_literal: true

require "fotmob"
require "vcr"
require "webmock/rspec"

# Configure VCR to record HTTP interactions for testing
VCR.configure do |config|
  config.cassette_library_dir = "spec/fixtures/vcr_cassettes"
  config.hook_into :webmock
  config.configure_rspec_metadata!
  config.default_cassette_options = {
    record: :new_episodes,
    match_requests_on: %i[method uri]
  }
end

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  # Use color in output
  config.color = true

  # Use documentation format for readable test output
  config.formatter = :documentation

  # Integration tests hit the live API — skip unless FOTMOB_INTEGRATION=true
  config.filter_run_excluding :integration unless ENV["FOTMOB_INTEGRATION"] == "true"

  # Allow real HTTP for integration tests; block everything else via WebMock/VCR
  config.around(:each, :integration) do |example|
    VCR.turned_off do
      WebMock.allow_net_connect!
      example.run
      WebMock.disable_net_connect!
    end
  end
end
