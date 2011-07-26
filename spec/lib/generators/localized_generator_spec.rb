require 'spec_helper'
require "generator_spec/test_case"
require 'generators/localized/localized_generator'

describe LocalizedGenerator do
  include GeneratorSpec::TestCase
  destination File.expand_path("../../../../tmp", __FILE__)

  before do
    prepare_destination
    run_generator
  end

  specify do
    destination_root.should have_structure {
      no_file "sites.rb"
      directory "app" do
        directory "concerns" do
          directory "localized" do
            file "sites.rb" do
              contains "# this file was originally generated by the localized generator"
              contains "module Localized::Sites"
              contains "bitfield :sites,"
              contains "default_scope"
            end
          end
        end
      end
      no_file "localized.yml"
      directory "config" do
        file "localized.yml" do
          contains "# this file was originally generated by the localized generator"
          contains "default_site"
          contains "us: 'en-US'"
        end
      end
    }
  end
end
