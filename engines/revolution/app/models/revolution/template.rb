module Revolution
  class Template < ActiveRecord::Base

    attr_accessible :name, :custom, :data

    validate :name, :data, :presence => true

    has_many :pages

    def path
      return data if custom?
    end
  end
end
