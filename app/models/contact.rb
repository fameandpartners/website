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
  attr_accessor :name, :linkedin, :interests, :join_team

  validates :site_version, presence: true
  validates :email, format: /^[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}$/i, presence: true

  with_options if: :contact_form? do |contact|
    contact.validates :first_name, :last_name, :subject, :message, presence: true
  end

  with_options if: :join_us_form? do |join_team|
    join_team.validates :name, :interests, presence: true
    join_team.validates :linkedin, format: { with: /\A((http|https):\/\/)?(www.)?linkedin.com\//, message: 'use a valid LinkedIn URL' },
      if: Proc.new { |c| c.linkedin.present? }
  end

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

  def contact_form?
    join_team.nil?
  end

  def join_us_form?
    join_team.present?
  end

end
