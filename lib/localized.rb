require 'rails'
require 'action_view'
require 'action_controller'
require 'active_model'
module Localized; end
require 'localized/config'
require 'localized/helper'

# load the modules into the rails world
[
  ActionView::Helpers::UrlHelper, 
  ActionController::Base
].each { |mod| mod.send :include, Localized::Helper }

