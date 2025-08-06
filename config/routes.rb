Rails.application.routes.draw do
  resources :photos do
    collection do
      delete 'destroy_all'
      delete 'reset_all' # Esta linha é essencial
    end
  end
end
