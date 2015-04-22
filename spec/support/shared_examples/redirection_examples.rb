# Wrapper for simple GET requests that should redirect.
#
# Mostly useful for the many, many SEO redirects we have to do for the new site.
#
# Usage
#
# 1. Create a spec of `type: request`
# 2. Use rspec's `it_behaves_like`, or the alias `it_will` to include the shared example.
#
# describe 'Page Redirection', type: :request do
#   it_will :redirect, '/from', '/to'
#
#   it_will "redirect to root", '/super_old_page'
# end

RSpec.shared_examples :redirect do |inbound, target|
  it "from '#{inbound}' to '#{target}'" do
    get inbound
    expect(response).to redirect_to(target)
  end
end

# Convenience example.
RSpec.shared_examples "redirect to root" do |url|
  it "'#{url}' to '/'" do
    get url
    expect(response).to redirect_to("/")
  end
end