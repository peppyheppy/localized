# load a rails app so we can test rails controllers,
# views, etc
class Application < Rails::Application
  # abusing locale for site/locale
  config.i18n.default_locale = :'en-US'
  config.active_support.deprecation = :stderr
end
Application.initialize!

# bogus controller for testing only
class FoobarController < ::ActionController::Base
  def test
    render :text => 'success'
  end
end

Rails.application.routes.draw do
  get '/test' => 'foobar#test', :as => :test
  root :to => "foobar#test"
end

