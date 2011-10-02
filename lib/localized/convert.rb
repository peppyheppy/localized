# coding: UTF-8
require 'csv'
require 'psych'
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

  def self.from_csv(file)
    new_translations = build_translation_hash(file)
    # write out translations to files
    content = translations
    new_translations.each do |token, locales|
      locales.each do |locale, value|
        content[locale] ||= {}
        content[locale] = formalize_translations(content[locale], token, value)
      end
    end
    content.each do |filename, file_contents|
      File.open("#{Rails.root}/config/locales/#{filename}.yml", "w") do |out|
        out.puts YAML.dump(stringify_keys(filename => file_contents)).force_encoding('UTF-8')
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

  def self.stringify_keys(h)
    h.inject({}) { |a, (k,v)| a[k.to_s] = v.is_a?(Hash) ? stringify_keys(v) : v; a }
  end

  def self.formalize_translations(existing, token, value)
    token_path = token.split('.')
    if token_path.size == 1
      existing[token] = value
    else
      first_token = token_path.first
      remaining_token = token_path[1..-1].join('.')
      existing[first_token] ||= {}
      existing[first_token] = formalize_translations(existing[first_token], remaining_token, value)
    end
    existing
  end

  def self.build_translation_hash(file)
    # build a new hash for translations
    locale_columns = []
    local_translations = {}
    CSV.foreach(file) do |row|
      if row[0] == "Token"
        locale_columns = row
      else
        locale_columns[1..-1].each_with_index do |locale, i|
          local_translations[row[0]] ||= translations[locale] || {}
          local_translations[row[0]][locale.to_sym] = row[i+1] && row[i+1].force_encoding("UTF-8")
        end
      end
    end
    local_translations
  end

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
