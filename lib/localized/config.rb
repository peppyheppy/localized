require 'yaml'

module Localized::Config
  def self.configuration
    @configuration ||= begin
      config_file = File.expand_path(File.join(Rails.root.to_s,'/config/localized.yml'))
      defaults_file = File.expand_path(File.join(__FILE__, '..', '..', '..', 'config/defaults.yml'))
      defaults = YAML.load_file(defaults_file)
      custom   = YAML.load_file(config_file) if File.exists?(config_file)
      symobolize_keys_and_values(defaults.merge(custom || {}))
    end.symbolize_keys
  end

  def self.default_host_prefix
    @default_host_prefix ||= self.configuration[:default_host_prefix].to_s
  end

  def self.site_to_locale_map
    @site_to_locale_map ||= self.configuration[:site_locale_map].symbolize_keys
  end

  def self.locale_to_site_map
    @locale_to_site_map ||= site_to_locale_map.invert
  end

  def self.default_site
    @default_site ||= self.configuration[:default_site]
  end  
  
  def self.supported_sites
    @supported_sites ||= site_to_locale_map.symbolize_keys.keys.sort
  end

  def self.supported_locales
    @supported_locales ||= site_to_locale_map.values.sort
  end

  def self.default_locale
    @default_locale ||= site_to_locale_map[default_site]
  end

  private

  def self.symobolize_keys_and_values(hash_name)
    new_hash = HashWithIndifferentAccess.new({})
    hash_name.each do |k,v| 
      if v.is_a? Hash
        new_hash[k.to_sym] = symobolize_keys_and_values(v)
      else
        new_hash[k.to_sym] = v.to_s.to_sym
      end
    end
    new_hash
  end
end
