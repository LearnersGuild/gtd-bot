Rails.application.routes.draw do
  resource :home, controller: :home, only: [:index]

  root to: "home#index"
end
