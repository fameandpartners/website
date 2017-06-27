require_dependency "wedding_atelier/application_controller"
module WeddingAtelier
  class EventsController < ApplicationController
    include WeddingAtelier::Concerns::DummyData
    protect_from_forgery except: :update

    before_filter :check_signup_completeness, only: :index
    before_filter :set_dummy_data, :prepare_form_default_values, only: :new

    def index
      event = current_spree_user.events.last
      redirect_to event_path(id: event.id, slug: event.slug)
    end

    def show
      @event = WeddingAtelier::Event.find(params[:id])
      @sizes = Spree::OptionType.size.option_values
      @heights = WeddingAtelier::Height.definitions
      @serialized_user = WeddingAtelier::UserSerializer.new(spree_current_user, root: false)

      if @event.nil? || !@event.assistant_permitted?(current_spree_user)
        flash[:notice] = "You don't have permission to access this wedding board"
        redirect_to wedding_atelier.events_path
      else
        respond_to do |format|
          format.html
          format.json { render json: @event, serializer: MoodboardEventSerializer }
        end
      end
    end

    def new; end

    def update
      @event = current_spree_user.events.find(params[:id])
      if @event.update_attributes(params_event) && spree_current_user.update_role_in_event(params[:event][:role], @event)
        render json: @event, serializer: MoodboardEventSerializer
      else
        render json: {errors: @event.errors}, status: 422
      end
    end

    private
    def params_event
      params[:event].slice(:name, :date, :number_of_assistants)
    end

    def check_signup_completeness
      if current_spree_user && !current_spree_user.wedding_atelier_signup_complete?
        redirect_to controller: :events, action: :new
      end
    end

    def prepare_form_default_values
      @user = current_spree_user

      @user.build_user_profile if @user && !@user.user_profile

      @roles = {
        'Bride' => 'bride',
        'Bridesmaid' => 'bridesmaid',
        'Maid of Honor' => 'maid of honor',
        'Mother of Bride' => 'mother of bride'
      }

      @heights = WeddingAtelier::Height.definitions.to_a

      @site_version = env['site_version_code'] || 'us'
      @dress_sizes = Spree::OptionType.size.option_values.each_slice(4).to_a
    end
  end
end
