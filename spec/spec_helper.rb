require "rubygems"
require "bundler/setup"
require "ruby-debug"
require "localized"
require "action_controller/railtie"
require 'rspec/rails'
require 'rspec/mocks'
require 'rspec/rails/mocks'

class Application < Rails::Application
  # abusing locale for site/locale
  config.i18n.default_locale = :'en-US'
end
Application.initialize!

class FoobarController < ::ActionController::Base
  def test
    render :text => 'success'
  end
end

Rails.application.routes.draw do
  get '/test' => 'foobar#test', :as => :test
  root :to => "foobar#test"
end

