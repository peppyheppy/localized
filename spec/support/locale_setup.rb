# used to setup a certain configuration for yaml fixtures
def setup_locale_fixtures(fixture_dirname)
  original_path = I18n.load_path
  path = "spec/fixtures/#{fixture_dirname}"
  if Dir.exist?(path)
    I18n.load_path = Dir[File.join("#{path}/*.yml")]
  else
    raise ArgumentError, "fixtures do not exist!"
  end
end
