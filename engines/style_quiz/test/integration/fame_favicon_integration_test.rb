require 'test_helper'

describe 'fame favicon static files' do
  include Capybara::DSL

  describe 'all files' do
    %w[
        android-chrome-144x144.png
        android-chrome-192x192.png
        android-chrome-36x36.png
        android-chrome-48x48.png
        android-chrome-72x72.png
        android-chrome-96x96.png
        apple-touch-icon-114x114.png
        apple-touch-icon-120x120.png
        apple-touch-icon-144x144.png
        apple-touch-icon-152x152.png
        apple-touch-icon-180x180.png
        apple-touch-icon-57x57.png
        apple-touch-icon-60x60.png
        apple-touch-icon-72x72.png
        apple-touch-icon-76x76.png
        apple-touch-icon-precomposed.png
        apple-touch-icon.png
        browserconfig.xml
        favicon-16x16.png
        favicon-194x194.png
        favicon-32x32.png
        favicon-96x96.png
        favicon.ico
        manifest.json
        mstile-144x144.png
        mstile-150x150.png
        mstile-310x150.png
        mstile-310x310.png
        mstile-70x70.png
    ].each do |static_file|
      it "provides /#{static_file}" do
        visit "/#{static_file}"
        page.status_code.must_equal(200)
      end
    end
  end

  describe 'files with text content' do
    {
      'browserconfig.xml' => '#eeddf0',
      'manifest.json'     => 'Fame & Partners'
    }.each do |static_file, content|
      it "provides /#{static_file}" do
        visit "/#{static_file}"
        page.status_code.must_equal(200)
        page.text.must_include content
      end
    end
  end
end
