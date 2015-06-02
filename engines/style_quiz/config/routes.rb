StyleQuiz::Engine.routes.draw do
  root to: 'profiles#new'

  resources :profiles
end
