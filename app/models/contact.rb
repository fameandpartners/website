class Contact
  include ActiveModel::Validations

  SUBJECTS = [
    [
      'Help making a purchase',
      ['Delivery', 'Fabrics','Product', 'Styling tips', 'Customization', 'Size']
    ],
    [
      'Help with an existing purchase',
      [
        'Order Status', 'Order Cancellation','Address Change Request',
        'Tracking Number','Lost Package','Missing Item','Wrong Item/Order Received',
        'Damaged/Defective Item','Return','Refund','Site Issues'
      ]
    ],
    [
      'Something else',
      [
        'Book a Style Consultation',
        'Feedback on the website',        
        'None of these apply to me'
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
