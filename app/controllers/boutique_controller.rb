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
      @user = boutique.user

      @competition_share_url = main_app.new_competition_entry_url(boutique.competition_share_url_params)
      # to make it workable on dev
      #@competition_share_url = main_app.new_competition_entry_url(
      #  boutique.competition_share_url_params.merge(host: 'stage.fameandpartners.com', port: '80')
      #)

      render 'competition'
    else
      render 'show'
    end
  end

  def url_with_correct_site_version
    main_app.url_for(params.merge(site_version: current_site_version.code))
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
      sorted_dresses.first(12)
    end

    def other_dresses
      sorted_dresses.from(12)
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

    def competition_share_url_params
      return {} if @actor.blank?
      invite = Competition::Invite.fb_invite_from(@actor, competition)

      url_params = {
        invite: invite.token,
        fb_ref: 'competition',
        fb_source: 'message'
      }
      url_params
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
      # trying to associate user
      if session[:style_profile_id]
        profile = UserStyleProfile.where(id: session[:style_profile_id])
        if profile.token == session[:style_profile_access_token]
          if user.present? && profile.user_id.blank?
            profile.update_column(:user_id, user.id)
            session[:style_profile_id] = nil
            session[:style_profile_access_token] = nil
          end
          return profile
        end
      end

      if user.style_profile.present? 
        return user.style_profile
      else
        raise CanCan::AccessDenied
      end
    end

    def sorted_dresses
      @sorted_dresses ||= Spree::Product.recommended_for(style_profile, :limit => 28)
    end
  end
end
