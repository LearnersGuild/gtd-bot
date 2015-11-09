Rails.application.routes.draw do
  resource :home, controller: :home, only: [:index] do
    get :test_bot, on: :collection
  end

  root to: "home#index"
end
