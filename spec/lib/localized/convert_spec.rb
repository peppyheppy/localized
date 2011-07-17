require 'spec_helper'

describe Localized::Convert do
  include Localized
  before :all do
    I18n.load_path = Dir[File.join('spec/config/locales/*.yml')]
  end

  describe "Locale cache" do
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

    it "should not have empty valueless keys" do
      Convert.locale_cache.should_not have_key 'one.two'
    end
  end

  describe "CSV export" do
    it "should convert the locale cache to a CSV file" do
      file = 'spec/test_csv.csv'
      File.should_not exist file
      Convert.to_csv(file)
      File.should exist file
      rows = CSV.read(file)
      # header row
      rows.first[0].should == "Token"
      rows.first[1].should == "en-US"
      rows.first[2].should == "es-ES"
      rows.first[3].should == "nl-NL"
      rows.first[4].should be_nil

      # data row
      rows.last[0].should == "one.two.three"
      rows.last[1].should == "three"
      rows.last[2].should be_nil
      rows.last[3].should == "another"
      rows.last[4].should be_nil

      File.delete(file)
    end
  end

end
