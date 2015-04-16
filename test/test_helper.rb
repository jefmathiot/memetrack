ENV['RAILS_ENV'] ||= 'test'

require 'simplecov'
SimpleCov.start

require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'mocha/setup'

module ActiveSupport
  class TestCase
    include FactoryGirl::Syntax::Methods
  end
end

module ActionController
  class TestCase
    class << self
      def with_request_formats
        %w(html json).each do |format|
          describe "with a #{format} request" do
            yield format if block_given?
          end
        end
      end

      def with_result_states(verb)
        { success: "succesfully #{verb}s", failure: "fails to #{verb}" }
          .each do |result, message|
          yield result, message if block_given?
        end
      end
    end
  end
end
