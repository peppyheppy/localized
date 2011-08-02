require 'spec_helper'

describe FoobarController , "locale specific routes", :type => :controller do
  before :all do
    Rails.stub(:root).and_return(Pathname.new(File.join(File.dirname(__FILE__),'..', '..')))
  end

  describe "sites and subdomain" do
    before :each do
      @request.host = "www.mysite.test"
    end

    it "should have the regular tests host" do
      root_url.should == 'http://www.mysite.test/'
    end

    it "should have the default host prefix and default locale" do
      root_url(:site => 'us').should == 'http://www.mysite.test/'
    end

    it "should error if site is not supported" do
      expect {
        root_url(:site => 'cz')
      }.to raise_error(ArgumentError)
    end

    it "should allow for locale override" do
      root_url(:site => 'it').should == 'http://www.it.mysite.test/'
    end

    it "should set the default site when Locale is set" do
      original_locale = I18n.locale
      I18n.locale = Localized::Config.site_to_locale_map[:es]
      root_url.should == 'http://www.es.mysite.test/'
      I18n.locale = original_locale
    end

  end

  describe "when host is an ip address" do
    it "should not override the hostname if the ip address is local" do
      @request.host = '127.0.0.1'
      get :test
      root_url.should == 'http://127.0.0.1/'
    end

    it "should not override the hostname if the ip address is local" do
      @request.host = '64.24.234.234'
      get :test
      root_url.should == 'http://64.24.234.234/'
    end
  end

  describe "additional helpers" do
    it "should have localized_site helper" do
      get :test
      controller.localized_site.should == :us
    end
  end

  describe "subdomain locale" do

    it "should set the current locale to that of the subdomain" do
      @request.host = "www.us.example.com"
      get :test
      I18n.locale.should == :"en-US"
    end

    it "should set the current locale to that of the subdomain" do
      @request.host = "www.it.example.com"
      get :test
      I18n.locale.should == :"it-IT"
    end

  end
end
