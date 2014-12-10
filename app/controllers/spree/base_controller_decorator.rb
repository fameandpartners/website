Spree::BaseController.class_eval do
  def url_with_correct_site_version
    #url_for(params.merge(site_version: current_site_version.code))
    '/' + current_site_version.code + request.fullpath
  end
end
