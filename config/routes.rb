# config/routes.rb
Rails.application.routes.draw do
  resources :photos do
    collection do
      delete 'destroy_all'
      delete 'reset_all'
    end
  end
  
  resources :videos, only: [:create, :index] do
    collection do
      delete 'reset_all'
    end
  end

  # --- ROTA ADICIONADA AQUI ---
  namespace :export do
    get 'download_media'
  end
end