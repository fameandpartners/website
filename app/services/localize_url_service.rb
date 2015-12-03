class LocalizeUrlService
  class << self
    # TODO: This method must get out of here, since it no longer makes sense with other site version detectors strategy.
    # This will be replaced by [Subdomain, Domain, Path]#site_version_url
    def localize_url(url, site_version)
      locales_paths = SiteVersion.permalinks.map { |sv| "/#{sv}" }
      locales_regex = Regexp.union(locales_paths)
      url_without_locale = url.gsub(locales_regex, '')
      uri = URI.parse(url_without_locale)

      new_uri = URI.join("#{uri.scheme}://#{uri.host}:#{uri.port}", "./#{site_version.to_param}/", "./#{uri.path}")
      new_uri.query = uri.query
      new_uri.to_s
    rescue URI::InvalidURIError => _
      url
    end

    def remove_version_from_path(url)
      locales_paths = SiteVersion.permalinks.map { |sv| "/#{sv}/" }
      locales_regex = Regexp.union(locales_paths)
      url.to_s.gsub(locales_regex, '/')
    end
  end
end
