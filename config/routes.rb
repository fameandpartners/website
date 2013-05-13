FameAndPartners::Application.routes.draw do

  match '/form' => 'pages#form'

  # Static pages
  get '/about'   => 'pages#about'
  get '/vision'  => 'pages#vision'
  get '/team'    => 'pages#team'
  get '/terms'   => 'pages#terms'
  get '/privacy' => 'pages#privacy'
  get '/legal' => 'pages#legal'

  root :to => 'pages#home'

  mount Spree::Core::Engine, at: '/'
end
