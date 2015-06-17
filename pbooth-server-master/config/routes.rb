require 'resque/server'

Pbooth::Application.routes.draw do

  root :to => "home#admin"
  get '/home', :to => "home#index"
  get '/admin', :to => "home#admin", as: "admin"
  get '/last_updated', :to => "home#last_updated"
  get '/list', :to => "home#list", as: "list"
  get '/settings', :to => "home#settings", as: "settings"
  get '/branding/:id', :to => "branding#show", as: "branding"

  mount Resque::Server.new, :at => "/resque"

  get "events/settings", to: "events#settings", defaults: { format: 'json' }
  get "events/:id/photos", to: "events#photos", defaults: { format: 'json' }
  resources :events
  post "events/:id/activate", :to => "events#activate", as: "activate_event"
  post "events/:id/deactivate", :to => "events#deactivate", as: "deactivate_event"

  resources :photos
  post 'photos/:id/print', :to => "photos#print"
  post 'photos/:id/share', :to => "photos#share"
  get 'photos/:id/original', to: "photos#show_original"
  get 'photos/:id/zoom', to: "photos#show_branded"
  get 'photos/:id/display', to: "photos#show"

  resources :photosets
  get '/gifs', :to => "home#gifs"
  get 'photosets/:id/zoom', to: "photosets#show_branded"
  get 'photosets/:id/display', to: "photosets#show"
  post 'photosets/:id/print', :to => "photosets#print"
  post 'photosets/:id/share', :to => "photosets#share"

  # Omnmiauth callback url
  match '/auth/:provider/callback', to: 'sessions#create', via: :get
  match 'auth/failure', to: redirect('/authentication_failure'), via: :get
  match 'signout', to: 'sessions#destroy', as: 'signout', via: :get

  get '/signed_in/:user/done', :to => "home#signed_in", as: "signed_in"
  get '/authentication_failure', :to => "home#authentication_failure", as: "authentication_failure"

  post 'email_gif', to: 'home#send_gif_email'
  #get 'sms', to: 'text_message#twilio'
  #get 'mms', to: 'text_message#mogreet'
  #get 's3', to: 'shares#amazon_s3'
  get 'smugmug', to: 'shares#smugmug'

  post 'twitter', to: 'shares#twitter'
  post 'facebook', to: 'shares#facebook'
  #get 'picasa', to: 'shares#picasa'
end
