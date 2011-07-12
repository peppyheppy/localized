require 'spec_helper'

class FoobarController < ::ActionController::Base
  def test
    render :text => 'success'
  end
end

describe FoobarController , "locale specific routes", :type => :controller do
  before :all do
    Rails.stub(:root).and_return(Pathname.new(File.join(File.dirname(__FILE__),'..', '..')))
    Rails.application.routes.draw do
      get '/test' => 'foobar#test', :as => :test
      root :to => "foobar#test"
    end
  end

  after :all do
    silence_warnings do
      Rails.application.reload_routes!
    end
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
