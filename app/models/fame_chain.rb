class FameChain
  include ActiveModel::Validations

  attr_accessor :name,
                :email,
                :blog,
                :facebook,
                :facebook_size,
                :instagram,
                :instagram_size,
                :pinterest,
                :pinterest_size,
                :other,
                :to_key

  validates_presence_of :name, :email
  validates_format_of :email, with: /^[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}$/i

  def initialize(attributes = {})
    attributes.each do |name, value|
      public_send("#{name}=", value)
    end
  end

  def to_key
    nil
  end
end
