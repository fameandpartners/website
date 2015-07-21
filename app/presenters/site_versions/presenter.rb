module SiteVersions
  class Presenter
    class << self
      def select_all(*attrs)
        SiteVersion.select(attrs).all
      end

      def options_for_select
        select_all(:name, :permalink).map do |site_version|
          [
            site_version.name,
            site_version_path(site_version),
            { 'data-flag-url' => flag_url(site_version) }
          ]
        end
      end

      private

      def site_version_path(site_version)
        Rails.application.routes.url_helpers.site_version_path(id: site_version.permalink)
      end

      def flag_url(site_version)
        ActionController::Base.helpers.asset_path("flags/#{site_version.permalink}.png")
      end
    end
  end
end
