Rails.application.routes.draw do
  resources :buckets

  resources :issues

  match "/auth/:service/callback" => "services#create", :via => %i(get post)
  match "/auth/failure" => "services#failure",          :via => %i(get post)
  match "/logout" => "sessions#destroy",                :via => %i(get delete), :as => :logout

  resources :services, :only => %i(create destroy)

  root :to => "sessions#new"
end
