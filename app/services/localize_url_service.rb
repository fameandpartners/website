class LocalizeUrlService
  class << self
    def localize_url(url, site_version)
      begin
        locales_paths = SiteVersion.permalinks.map { |sv| "/#{sv}" }
        locales_regex = Regexp.union(locales_paths)
        url_without_locale = url.gsub(locales_regex, '')
        uri = URI.parse(url_without_locale)
        URI.join("#{uri.scheme}://#{uri.host}:#{uri.port}", "./#{site_version.to_param}/", "./#{uri.path}").to_s
      rescue URI::InvalidURIError => e
        url
      end
    end
  end
end
