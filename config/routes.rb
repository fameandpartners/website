FameAndPartners::Application.routes.draw do

  # Static pages for HTML markup
  match '/form' => 'pages#form'
  match '/posts' => 'pages#posts'
  match '/post' => 'pages#post'
  match '/celebrities' => 'pages#celebrities'
  match '/celebrity' => 'pages#celebrity'

  # Static pages
  get '/about'   => 'pages#about'
  get '/vision'  => 'pages#vision'
  get '/team'    => 'pages#team'
  get '/terms'   => 'pages#terms'
  get '/privacy' => 'pages#privacy'
  get '/legal' => 'pages#legal'

  resources :custom_dresses, :only => [:new, :create]
  resources :custom_dress_images, :only => [:create]

  root :to => 'pages#home'

  mount Spree::Core::Engine, at: '/'
end
