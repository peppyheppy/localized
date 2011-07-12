module Localized::Helper
  extend ActiveSupport::Concern

  included do
    if self.respond_to? :before_filter
      before_filter :set_locale
    end
  end

  def set_locale
    key = request.subdomains.last.to_s.to_sym
    unless Localized::Config.site_to_locale_map[key]
      key = Localized::Config.default_site
    end
    I18n.locale = Localized::Config.site_to_locale_map[key]
  end

  def url_for(options = nil)
    if options.kind_of?(Hash)
      options[:host] = with_locale(options.delete(:site))
    end
    super options
  end

  protected

  def with_locale(site = nil)
    current_site =  Localized::Config.locale_to_site_map[I18n.locale]
    site = if site.blank? and current_site != Localized::Config.default_site
      current_site
    else
      site || Localized::Config.default_site
    end.to_s.to_sym
     Localized::Config.site_to_locale_map.fetch(site) {
      raise ArgumentError,
        "the site locale alias #{site} does not exist in list: #{Localized::Config.site_to_locale_map.stringify_keys.keys.sort.join(', ')}",
        caller(5)
    }

    subdomain = (Localized::Config.default_site != site ? "#{site}." : nil)
    [Localized::Config.default_host_prefix, subdomain, request.domain, request.port_string].join
  end
end
