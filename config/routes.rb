Rails.application.routes.draw do
  use_doorkeeper

  devise_for :users

  # enable for oauth with login
  # devise_for :users, controllers: {
  #     sessions: "user/session"
  # }

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  namespace :user do
    get "/me", to: "user#me"
  end

end
