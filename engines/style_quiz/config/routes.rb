StyleQuiz::Engine.routes.draw do
  root to: 'profiles#new'

  resources :profiles, only: [:new, :create]
end
