require 'spec_helper'

ActionController::Base.prepend_view_path 'spec/views'

describe "widget_default.erb" do
  it "renders the widget partial with default locale set" do
    I18n.locale = I18n.default_locale
    render
    rendered.should =~ /www.test.host/
  end
end

describe "widget_helpers_test.erb" do
  it "renders the widget partial for localized_site helper" do
    I18n.locale = :'it-IT'
    render
    rendered.should =~ /it/
  end
end

describe "widget.erb" do
  it "renders the widget partial for it" do
    I18n.locale = :'it-IT'
    render
    rendered.should =~ /www.test.host/
  end
end

describe "widget_invalid.erb" do
  it "raises error when site does not exist" do
    expect {
      render
    }.to raise_exception(ActionView::Template::Error)
  end
end

