Spree::BaseController.class_eval do
  def url_with_correct_site_version
    #main_app.url_for(params.merge(site_version: current_site_version.code))
    if request.fullpath.include?("/au/") or request.fullpath.include?("/us/")
      path = request.fullpath.gsub(/^\/../, '')
    else
      path =  request.fullpath
    end

    '/' + current_site_version.code + path + "?"
  end
end
