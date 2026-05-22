# config/routes.rb
Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  resources :photos do
    collection do
      delete 'destroy_all'
      delete 'reset_all'
      get 'active_ids'
    end
  end
  
  resources :videos, only: [:create, :index] do
    collection do
      delete 'reset_all'
      get 'active_ids'
    end
  end

  namespace :export do
    get 'download_media'
  end

  get 'admin', to: 'admin#index'
  delete 'admin/photos/:id', to: 'admin#destroy_photo', as: :admin_destroy_photo
  delete 'admin/videos/:id', to: 'admin#destroy_video', as: :admin_destroy_video
end