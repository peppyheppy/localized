require "rubygems"
require "bundler/setup"
require "ruby-debug"
require "localized"
require "action_controller/railtie"
require 'rspec/rails'
require 'rspec/mocks'
require 'rspec/rails/mocks'
require 'support/setup_rails'

Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  config.before(:each) do
    if example.metadata[:locales]
      setup_locale_fixtures(example.metadata[:locales])
    end
  end
end

