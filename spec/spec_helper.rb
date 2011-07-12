require "rubygems"
require "bundler/setup"
require "ruby-debug"
require "localized"
require "action_controller/railtie"
require 'rspec/rails'

class Application < Rails::Application
  # abusing locale for site/locale
  config.i18n.default_locale = :'en-US'
end
Application.initialize!

