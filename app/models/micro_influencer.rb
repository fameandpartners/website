class MicroInfluencer
  include ActiveModel::Validations

  def to_key
    nil
  end

  def persisted?
    false
  end
end
