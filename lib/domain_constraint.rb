class DomainConstraint
  def initialize(domain)
    @domains = domain
  end

  def matches?(request)
    @domains.match request.referer
  end
end