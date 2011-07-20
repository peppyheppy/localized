require 'csv'
module Localized::Convert

  def self.to_csv(file)
    CSV.open(file, "wb") do |csv|
      csv << ["Token", *locale_columns]
      locale_cache.keys.sort.each do |token|
        row = [token]
        locale_columns.each do |locale|
          row << locale_cache[token][locale]
        end
        csv << row
      end
    end
    nil
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
      columns = Hash[locale_columns.map{|l| [l, nil]}]
      Localized::Config.supported_locales.each do |locale| # each locale
        formalize_keys(nil, (translations[locale] || {})).each do |(key, value)| # each translation
          rows[key] ||= columns
          rows[key] = rows[key].merge(locale => value)
        end
      end
      rows.reject { |k, r| r.values.compact.blank? }
    end
  end

  private

  def self.formalize_keys(key, value)
    pairs = []
    if value.is_a?(Hash)
      value.each do |new_key, new_value|
        pairs << formalize_keys("#{key}#{key && "."}#{new_key}", new_value)
      end
    elsif value.is_a? String
      pairs << [key, value]
    end
    Hash[*pairs.flatten].to_a
  end

  def self.locale_columns
    @locale_columns ||= [
      Localized::Config.default_locale,
      *Localized::Config.supported_locales.reject { |t| t == Localized::Config.default_locale }
    ]
  end

end
