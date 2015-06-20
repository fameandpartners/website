StyleQuiz::Engine.routes.draw do
  root to: 'user_profiles#edit'

  resource :user_profile, only: [:edit, :update, :show] do
    resources :events, only: [:create, :update, :destroy]
  end

  Spree::Core::Engine.routes.prepend do
    namespace :admin do
      namespace :style_quiz do # todo make it configurable
        resources :tags
        #resources :questions
        #resources :products

        root to: 'tags#index'
      end
    end
  end
end
