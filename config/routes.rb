Rails.application.routes.draw do
  resource :home, controller: :home, only: [:index] do
    get :test_bot, :clear_cache, on: :collection
  end

  root to: "home#index"
end
