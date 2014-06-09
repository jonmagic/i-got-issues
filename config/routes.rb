Rails.application.routes.draw do
  resources :buckets, :only => [:index, :new, :edit, :create, :update, :destroy]
  resources :prioritized_issues, :only => [:create, :update, :destroy] do
    patch :move_to_bucket, :as => :move_to_bucket
    post :sync, :as => :sync
  end
  resources :teams, :only => :index
  get "/user/set_team", :to => "user#set_team", :as => :set_team

  match "/auth/:service/callback" => "services#create", :via => %i(get post)
  match "/auth/failure" => "services#failure",          :via => %i(get post)
  match "/logout" => "sessions#destroy",                :via => %i(get delete), :as => :logout

  resources :services, :only => %i(create destroy)

  root :to => "sessions#new"
end
