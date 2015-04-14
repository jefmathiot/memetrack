require 'capybara/cucumber'
require 'capybara/poltergeist'
require 'securerandom'
require 'yaml'
require 'erb'

module MemeTrack
  class << self
    def host
      @host ||= `cd ..;docker-compose port web 80`.chomp
      STDOUT.puts "Testing against http://#{@host}"
      "http://#{@host}"
    end

    def random_tags
      ([0] * 2).map { SecureRandom.hex(8) }
    end
  end
end

Capybara.register_driver :poltergeist do |app|
  options = { js_errors: true }
  Capybara::Poltergeist::Driver.new(app, options)
end

Capybara.default_driver = :poltergeist
Capybara.run_server = false
Capybara.app_host = MemeTrack.host
Capybara.default_wait_time = 5
