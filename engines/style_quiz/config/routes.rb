StyleQuiz::Engine.routes.draw do
  root to: 'user_profiles#edit'

  resource :user_profile, only: [:edit, :update, :show] do
    resources :events, only: [:create, :update, :destroy]
  end

  Spree::Core::Engine.routes.prepend do
    namespace :admin do
      namespace :style_quiz do # todo make it configurable
        resources :tags
        resources :questions do
          resources :answers, on: :member
          post      :order, to: 'questions#order', on: :collection
        end
        resources :products, only: [:index, :edit, :update, :destroy]
        resources :user_profiles, only: [:index, :show]

        root to: 'tags#index'
      end
    end
  end
end
