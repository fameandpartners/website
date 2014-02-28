class BoutiqueController < Spree::StoreController
  layout 'spree/layouts/spree_application'
  respond_to :html

  # load user or use current
  # check user style profile
  def show
    boutique = BoutiqueView.new(try_spree_current_user, params.extract!(:user_id, :competition_id))

    @style_profile = boutique.style_profile
    @recommended_dresses = boutique.recommended_dresses
    @dresses = boutique.other_dresses
    #http://www.fameandpartners.com/gregg-sulkin?invite=h_boRyLwO2MPT9LDixfumw&fb_ref=competition&fb_source=message

    if boutique.competition.present?
      @celebrity_style_profile = boutique.celebrity_style_profile
      @celebrity_dresses = boutique.celebrity_dresses
      @fb_invite = boutique.competition_fb_invite
      @user = boutique.user

      render 'competition'
    else
      render 'show'
    end
  end

  private

  class BoutiqueView
    def initialize(actor, options = {})
      @actor = actor
      @options = options
    end

    def style_profile
      @style_profile ||= get_user_style_profile
    end

    def recommended_dresses
      sorted_dresses.first(8)
    end

    def other_dresses
      sorted_dresses.from(8)
    end

    def celebrity_style_profile
      Competition.gregg_style_profile
    end

    def celebrity_dresses
      @celebrity_dresses ||= Spree::Product.recommended_for_style_profile(celebrity_style_profile, 3)
    end

    def competition
      id = @options[:competition_id]
      id.present? && Competition.exists?(id) ? id : nil
    end

    def competition_fb_invite
      @actor.present? ? Competition::Invite.fb_invite_from(@actor, competition) : nil
    end

    def user
      @user ||= get_user
    end

    private

    def get_user
      if @options[:user_id].present?
        result = Spree::User.find_by_slug(@options[:user_id])
      else
        result = @actor
      end
      raise CanCan::AccessDenied if result.blank?
      result
    end

    def get_user_style_profile
      if user.style_profile.present? 
        return user.style_profile
      else
        raise CanCan::AccessDenied
      end
    end

    def sorted_dresses
      @sorted_dresses ||= Spree::Product.recommended_for(user, :limit => 28)
    end
  end
end
=begin

class MyBoutiqueController
  user
  raise PermissionDenied ? with auto catch/redirect to home
  competition
end

  def check_style_profile_presence!
    unless current_spree_user.style_profile.present?
      raise CanCan::AccessDenied
    end
  end
=end
