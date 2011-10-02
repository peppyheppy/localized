require 'rails'
require 'action_view'
require 'action_controller'
require 'active_model'
require 'i18n'
module Localized; end
require 'localized/config'
require 'localized/helper'
require 'localized/convert'
require 'bitfields'

# set default encoding
Encoding.default_internal = 'UTF-8'

# load the modules into the rails world
[
  ActionView::Base,
  ActionController::Base
].each { |mod| mod.send :include, Localized::Helper }
