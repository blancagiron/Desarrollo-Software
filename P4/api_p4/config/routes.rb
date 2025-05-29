Rails.application.routes.draw do
  resources :envios, only: [:index, :show, :create, :update, :destroy]
  
  # Ruta adicional para ver todas las rutas
  root 'envios#index'
end
