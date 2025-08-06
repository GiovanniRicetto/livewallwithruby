# config/initializers/cors.rb
Rails.application.config.middleware.insert_before 0, Rack::Cors do
    allow do
      # Permite requisições de qualquer origem.
      # Para mais segurança em produção, você pode restringir a `origins 'https://seu-dominio.com'`
      origins '*'
  
      resource '*',
        headers: :any,
        methods: [:get, :post, :put, :patch, :delete, :options, :head]
    end
  end