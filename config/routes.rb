Rails.application.routes.draw do
  resources :licitacoes, only: [:index, :new, :create]

  get "up" => "rails/health#show", as: :rails_health_check

end
