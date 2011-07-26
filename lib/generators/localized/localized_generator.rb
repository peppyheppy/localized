class LocalizedGenerator < Rails::Generators::Base
  desc "This generator copies a sample localized.yml and creates a concerns for
    scopes and site flags on active record models."
  argument :sites, :type => :array, :default => ['us:en-US', 'uk:en-UK', 'it:it-IT'], :banner => "site:locale us:en-US"

  def create_localized_config
    # create the
    create_file "config/localized.yml", <<-YAML_FILE
# this file was originally generated by the localized generator
default_host_prefix: 'www.'
default_site: 'us'
site_locale_map:
#{generate_yaml_from_sites}
    YAML_FILE
  end

  desc "create the concerns mixin for adding bitfield and default scope support"
  def create_concerns_lib
    create_file "app/concerns/localized/sites.rb", <<-SITES
# this file was originally generated by the localized generator
module Localized::Sites
  extend ActiveSupport::Concern

  included do
    # create bitfield for all supported sites
    include Bitfields
    # NOTE: order should not change, if it does site data may become corrupt.
    bitfield :sites,
#{generate_flags}

    # default scope to filter by current locale to site map
    default_scope self.send(Localized::Config.locale_to_site_map[I18n.locale])
  end
end
    SITES
  end

  private

  def generate_flags
    flag_idx = 0
    parsed_sites.map(&:first).map do |s|
      flag_idx = flag_idx == 0 ? 1 : flag_idx * 2
      "      #{flag_idx} => :#{s},"
    end.join("\n").chop
  end

  def generate_yaml_from_sites
    parsed_sites.map { |(s,l)| "  #{s.strip}: '#{l.strip}'"}.join("\n")
  end

 def parsed_sites
    sites.compact.map{|s| [*s.split(':')]}
  end

end
