Rails.application.routes.draw do
  # Primero la ruta de reset:
  delete '/envios/reset', to: 'envios#reset'

  # Luego el resto de recursos:
  resources :envios, only: [:index, :show, :create, :update, :destroy]

  root 'envios#index'
end
