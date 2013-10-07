class FameChain
  include ActiveModel::Validations

  attr_accessor :name, :email, :blog, :pinterest, :facebook, :twitter, :to_key

  validates :name, presence: true
  validates :email, format: /^[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}$/i, presence: true

  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end

  def persisted?
    false
  end

  def send_request
    if self.valid?
      FameChainMailer.fame_chain(self).deliver
      true
    else
      false
    end
  end
end
