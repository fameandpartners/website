# note:
#   - if member have bought dresses from bride moodboard.
#   - notify bride about it.
class Bridesmaid::CheckIsDressBoughtByMember
  attr_reader :order

  def initialize(options = {})
    @order = options[:order]
  end

  def process
    # find accessor
    # find bride partys where accessor is not bride
    # check bought dress
    # if dress bought from moodboard
    #   - update membership with 'bought'
    #   - notify
  end

  private
end
