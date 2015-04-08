ENV['RAILS_ENV'] ||= 'test'

require 'simplecov'
SimpleCov.start

require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'mocha/setup'

class ActiveSupport::TestCase
  include FactoryGirl::Syntax::Methods
end

class ActionController::TestCase

  class << self

    def with_request_formats(&block)
      ['html', 'json'].each do |format|
        describe "with a #{format} request" do
          yield format
        end
      end
    end

    def with_result_states(verb, &block)
      {success: "succesfully #{verb}s", failure: "fails to #{verb}"}.
        each do |result, message|
        yield result, message
      end
    end

  end

end
