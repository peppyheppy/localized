# coding: UTF-8
require 'spec_helper'
describe Localized::Convert do
  include Localized

  before :each do
    Rails.stub!(:root).and_return(Pathname.new(File.join(File.dirname(__FILE__),'..', '..')))
  end

  describe "Locale cache", :locales => :to_csv do
    it "should return cache keys for each unique key path" do
      Convert.locale_cache.detect { |k,v| k == 'one.two.three' }.should_not be_nil
    end

    it "should return a list of each locale for each key" do
      Convert.translations.keys.each do |key|
        Convert.locale_cache['one.two.three'].should include(key)
      end
    end

    it "should have an empty value for languages whose files do not have key" do
      Convert.locale_cache['one.two.three'][:'en-US'].should == 'three'
      Convert.locale_cache['one.two.three'][:'nl-NL'].should == 'another'
      Convert.locale_cache['one.two.three'][:'es-ES'].should be_nil
    end

    it "should have values set for one deep" do
      Convert.locale_cache['five'][:'en-US'].should == 'special'
    end

    it "should have values set for two deep" do
      Convert.locale_cache['one.four'][:'en-US'].should == 'hello'
    end

    it "should have values set for three deep" do
      Convert.locale_cache['one.two.six'][:'en-US'].should == 'moroni'
    end

    it "should have values set for six deep" do
      Convert.locale_cache['seven.eight.nine.ten.eleven'][:'en-US'].should == 'truth'
    end

    it "should not have empty valueless keys" do
      Convert.locale_cache.should_not have_key 'one.two'
    end

    it "should have the same keys that are listed in the localized config file" do
      Convert.locale_cache['one.two.three'].keys.sort.should == Localized::Config.supported_locales.sort
    end
  end

  describe "CSV export", :locales => :to_csv do
    before :each do
      I18n.load_path = Dir[File.join('spec/config/locales/*.yml')]
    end

    it "should convert the locale cache to a CSV file" do
      file = 'spec/test_csv.csv'
      #File.should_not exist file
      Convert.to_csv(file)
      File.should exist file
      rows = CSV.read(file)
      # header row
      # ["Token", "en-US", "de-DE", "en-AU", "en-CA", "en-GB", "es-ES", "fr-FR", "it-IT", "ja-JP", "nl-NL", "sv-SE"]
      rows.first[0].should == "Token"
      rows.first[1].should == "en-US"
      rows.first[2].should == "de-DE"
      rows.first[3].should == "en-AU"
      rows.first[4].should == "en-CA"
      rows.first[5].should == "en-GB"
      rows.first[6].should == "es-ES"
      rows.first[7].should == "fr-FR"
      rows.first[8].should == "it-IT"
      rows.first[9].should == "ja-JP"
      rows.first[10].should == "nl-NL"
      rows.first[11].should == "sv-SE"

      # data row
      # ["one.two.three", "three", nil, nil, nil, nil, nil, nil, nil, nil, nil, "another", nil]
      rows.last[0].should == "seven.eight.nine.ten.eleven"
      rows.last[1].should == "truth"
      rows.last[2].should be_nil
      rows.last[3].should be_nil
      rows.last[4].should be_nil
      rows.last[5].should be_nil
      rows.last[6].should be_nil
      rows.last[7].should be_nil
      rows.last[8].should be_nil
      rows.last[9].should be_nil
      rows.last[11].should be_nil

      File.delete(file)
    end
  end

  describe "CSV import", :locales => :from_csv do
    it "should update locale files from CSV file" do
      # setup
      original_path = I18n.load_path
      spec_config_locales = 'spec/config/locales/*.yml'
      FileUtils.rm Dir[spec_config_locales]

      Convert.from_csv('spec/fixtures/translations.csv')
      I18n.load_path = Dir[spec_config_locales]

      Convert.load_cache
      Convert.locale_cache['new.token.yo'][:'en-US'].should == "United States"
      Convert.locale_cache['new.token.yo'][:'es-ES'].should == "Spain"
      Convert.locale_cache['new.token.yo'][:'nl-NL'].should == "Netherlands"
      Convert.locale_cache['twelve'][:'en-US'].should == "awesome"
      Convert.locale_cache['japanese'][:'ja-JP'].should == "ここに入力"
      Dir[spec_config_locales].size.should == 4 # one for each language

      # cleanup
      FileUtils.rm Dir[spec_config_locales]
      I18n.load_path = original_path
    end
  end

end
