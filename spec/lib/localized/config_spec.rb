require 'spec_helper'

describe Localized::Config do

  before :each do
    Rails.stub(:root).and_return(Pathname.new(File.join(File.dirname(__FILE__),'..', '..')))
  end

  it "should load defaults" do
    Localized::Config.configuration.should_not be_nil
    Localized::Config.configuration.keys.should include :site_locale_map
  end

  it "should have site to local mappings" do
    Localized::Config.should respond_to :site_to_locale_map
    Localized::Config.site_to_locale_map.should be_a Hash
    Localized::Config.site_to_locale_map.keys.should include(:us)
  end

  it "should have local to site mappings" do
    Localized::Config.should respond_to :locale_to_site_map
    Localized::Config.locale_to_site_map.should be_a Hash
    Localized::Config.locale_to_site_map.keys.should include(:'en-US')
  end

  it "should have default site" do
    Localized::Config.should respond_to :default_site
    Localized::Config.site_to_locale_map.keys.should include(Localized::Config.default_site)
  end

  it "should have default host prefix" do
    Localized::Config.should respond_to :default_host_prefix
    Localized::Config.default_host_prefix.should == "www"
  end

  it "should have supported sites" do
    Localized::Config.should respond_to :supported_sites
    Localized::Config.supported_sites.should be_a Array
    Localized::Config.supported_sites.should include(:us) 
  end

  it "should have supported locales" do
    Localized::Config.should respond_to :supported_locales
    Localized::Config.supported_locales.should be_a Array
    Localized::Config.supported_locales.should include(:'en-US') 
  end

  it "should have default locale" do
    Localized::Config.should respond_to :default_locale
    Localized::Config.default_locale.should == :'en-US'
  end

end
