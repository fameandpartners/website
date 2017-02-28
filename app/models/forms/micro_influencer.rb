module Forms
  class MicroInfluencer < Reform::Form

    property :full_name, virtual: true
    property :email, virtual: true
    property :blog_url, virtual: true
    property :dress_size, virtual: true
    property :mailing_address, virtual: true
    property :social_handles_0, virtual: true
    property :social_handles_1, virtual: true
    property :social_handles_2, virtual: true
    property :social_handles_3, virtual: true
    property :social_handles_4, virtual: true

    validates :full_name,
              :email,
              :social_handles_0,
              presence: true

  end
end
