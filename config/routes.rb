Rails.application.routes.draw do
  resources :teams, :only => :index do
    get  "/"                      => "buckets#index"
    post "/archive_closed_issues" => "teams#archive_closed_issues"
    get  "/audit_log"             => "audit_entries#index"

    resources :buckets, :only => [:new, :edit, :create, :update, :destroy] do
      resources :prioritized_issues, :only => [:create, :update, :destroy] do
        post :sync, :as => :sync
        patch "move" => "prioritized_issues#move_to_bucket"
      end
    end

    resources :ship_lists, :only => [:index, :show]
    resources :import,     :only => [:index, :create]
  end

  post "/prioritized_issues"     => "prioritized_issues#bookmarklet_legacy"
  get  "/prioritized_issues/new" => "prioritized_issues#new", :as => :new_prioritized_issue

  get "/user/set_team", :to => "user#set_team", :as => :set_team

  match "/auth/:service/callback" => "services#create", :via => %i(get post)
  match "/auth/failure" => "services#failure",          :via => %i(get post)
  match "/logout" => "sessions#destroy",                :via => %i(get delete), :as => :logout

  resources :services, :only => %i(create destroy)

  root :to => "sessions#new"
end
