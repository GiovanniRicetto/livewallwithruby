# config/routes.rb
Rails.application.routes.draw do
  resources :photos do
    collection do
      delete 'destroy_all'
      delete 'reset_all'
    end
  end
  
  # --- ALTERAÇÃO AQUI ---
  resources :videos, only: [:create, :index] do
    collection do
      delete 'reset_all'
    end
  end
end