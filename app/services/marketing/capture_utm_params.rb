module Marketing; end

class Marketing::CaptureUtmParams
  attr_reader :user, :user_token, :utm_params

  def initialize(user, user_token, utm_params = {})
    @user       = user
    @user_token = user_token
    @utm_params = HashWithIndifferentAccess.new(valid_utm_params(utm_params))
  end

  def record_visit!
    return nil if !data_valid?
    generate_token

    record = scope.first_or_initialize
    record.visits = record.visits.to_i + 1
    record.assign_attributes(utm_params)

    record.save

    record
  end

  def user_token_created?
    @user_token_created.present?
  end

  private

    # fetch allowed params
    # limit it by 250 ( psql restriction 255 and campaign monitor doesn't allow more than 250 )
    def valid_utm_params(params)
      utm_params_keys = [:utm_campaign, :utm_source, :utm_medium, :utm_term, :utm_content, :referrer]
      result = {}
      utm_params_keys.each do |key|
        if params[key].present?
          result[key] = params[key].to_s.first(250)
        end
      end
      result
    end

    def data_valid?
      utm_params[:utm_campaign].present?
    end

    def scope
      if user.present?
        Marketing::UserVisit.where(
          spree_user_id: user.id, utm_campaign: utm_params[:utm_campaign]
        )
      else
        Marketing::UserVisit.where(
          user_token: user_token, utm_campaign: utm_params[:utm_campaign]
        )
      end
    end

    def generate_token
      if user.blank? && user_token.blank?
        @user_token         = SecureRandom.base64(64).tr('+/=', '-_ ').strip.delete("\n")[0..63]
        @user_token_created = true
      end
      @user_token
    end
end
