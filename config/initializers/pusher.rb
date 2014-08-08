# config/initializers/pusher.rb

if ENV["PUSHER_URL"].present?
  require 'pusher'

  Pusher.url = ENV["PUSHER_URL"]
  Pusher.logger = Rails.logger
end
