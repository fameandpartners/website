class Contact
  include ActiveModel::Validations

  SUBJECTS = [
    [
      'Place an Order',
      [
        'Delivery', 'Product', 'Styling Tips', 'Customization', 'Size'
      ]
    ],
    [
      'Help with an existing purchase',
      [
        'Order Status', 'Change Existing Order', 'Issue with Order', 'Returns & Exchanges'
      ]
    ],
    [
      'Something else',
      [
        'Site Issues',
        'Book a Style Consultation',
        'Retailer Questions',
        'None of These Apply to Me',
        "Fashion \"IT\" Girl"
      ]
    ]
  ]

  attr_accessor :first_name, :last_name, :email, :subject, :site_version, :message, :phone, :order_number

  validates :email, format: /^[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}$/i, presence: true
  validates :first_name, :last_name, :subject, :site_version, :message, presence: true

  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end

  def persisted?
    false
  end

  def to_key
    nil
  end
end
