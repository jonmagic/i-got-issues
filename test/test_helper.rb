ENV["RAILS_ENV"] ||= "test"
require File.expand_path("../../config/environment", __FILE__)
require "rails/test_help"
require "minitest/rails/capybara"
require "rack_session_access/capybara"

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :buckets, :issues, :prioritized_issues, :users

  # Add more helper methods to be used by all tests here...
end

VCR.configure do |c|
  c.cassette_library_dir = "test/fixtures/vcr_cassettes"
  c.hook_into :webmock
end

def login(user, access_token="fake_access_token")
  page.set_rack_session :user_id     => user.id
  page.set_rack_session :oauth_token => access_token
end
