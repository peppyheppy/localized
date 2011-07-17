require 'csv'
module Localized::Convert

  def self.to_csv(file)
    CSV.open(file, "wb") do |csv|
      csv << ["Token", translations.keys.sort].flatten
      locale_cache.keys.sort.each do |token|
        row = [token]
        locale_cache[token].keys.sort.each do |locale|
          row << locale_cache[token][locale]
        end
        csv << row
      end
    end
  end

  def self.load_cache
    I18n.backend.send(:init_translations)
  end

  def self.translations
    load_cache
    @translations ||= I18n.backend.send(:translations)
  end

  def self.locale_cache
    @locale_cache = begin
      rows = {}
      columns = Hash[translations.keys.map{|l| [l, nil]}]
      translations.keys.each do |locale| # each locale
        translations[locale].each do |key, value| # each translation
          key_string, value_string = formalize_keys(key, value)
          rows[key_string] ||= columns
          rows[key_string] = rows[key_string].merge(locale => value_string)
        end
      end
      rows.reject { |k, r| r.values.compact.blank? }
    end
  end

  private

  def self.formalize_keys(key, value)
    key_string = key.to_s
    value_string = nil
    if value.is_a? Hash
      value.each do |key, new_value|
        key_string += ".#{key}"
        key_string, value_string = formalize_keys(key_string, new_value)
      end
    else
      value_string = value
    end
    [key_string, value_string]
  end
end
