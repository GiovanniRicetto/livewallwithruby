require 'rails_helper'
require 'net/http'
require 'benchmark'

# Para rodar este teste isoladamente, use o comando:
# bundle exec rspec spec/performance/puma_load_spec.rb
RSpec.describe "Puma Performance & Load Test", type: :performance do
  # ATENÇÃO: O RSpec normalmente contorna o servidor web (Puma) usando Rack::Test.
  # Para validar a concorrência REAL do Puma (threads/workers), 
  # precisamos disparar requisições HTTP verdadeiras para a porta do servidor.
  # 
  # ANTES DE RODAR ESTE TESTE:
  # Inicie o servidor em outro terminal (como você roda em modo dev, basta iniciar normalmente):
  # bundle exec rails s -p 3000
  
  let(:base_url) { 'http://localhost:3000' }
  let(:photos_url) { URI("#{base_url}/photos") }
  let(:active_ids_url) { URI("#{base_url}/photos/active_ids") }
  
  # Quantidade de requisições simultâneas disparadas
  # Isso simula a quantidade de convidados abrindo o mural ou polling simultâneo
  let(:concurrent_requests) { 100 } 
  
  before(:all) do
    # Verifica rapidamente se o servidor Puma está rodando na porta 3000 antes de iniciar a carga
    begin
      Net::HTTP.get_response(URI('http://localhost:3000/'))
    rescue Errno::ECONNREFUSED
      puts "\n\e[31m[ERRO] O servidor Puma não está rodando em http://localhost:3000!\e[0m"
      puts "\e[33mPara o teste de performance do Puma funcionar, você precisa iniciar o servidor em outro terminal.\e[0m"
      puts "\e[33mComando: rails server\e[0m\n\n"
    end
  end

  it "suporta picos de requisições concorrentes no endpoint de polling (active_ids) sem falhar" do
    run_load_test(active_ids_url, concurrent_requests)
  end

  it "suporta picos de requisições concorrentes buscando a galeria inteira (photos) sem falhar" do
    run_load_test(photos_url, concurrent_requests)
  end

  private

  def run_load_test(uri, concurrency)
    success_count = 0
    failure_count = 0
    mutex = Mutex.new # Para atualizar as variáveis de forma segura entre as threads

    time_taken = Benchmark.realtime do
      threads = []
      
      concurrency.times do
        threads << Thread.new do
          begin
            response = Net::HTTP.get_response(uri)
            mutex.synchronize do
              if response.is_a?(Net::HTTPSuccess)
                success_count += 1
              else
                failure_count += 1
              end
            end
          rescue => e
            mutex.synchronize { failure_count += 1 }
          end
        end
      end
      
      # Aguarda todas as threads terminarem
      threads.each(&:join)
    end

    throughput = (concurrency / time_taken).round(2)

    puts "\n=================================================="
    puts "🚀 RESULTADO DO TESTE DE PERFORMANCE (PUMA)"
    puts "Endpoint Testado: #{uri.path}"
    puts "Requisições Concorrentes: #{concurrency}"
    puts "--------------------------------------------------"
    puts "Tempo Total: #{time_taken.round(3)} segundos"
    puts "Requisições por segundo: #{throughput} req/s"
    puts "Sucessos (HTTP 200): #{success_count}"
    puts "Falhas / Timeouts: #{failure_count}"
    puts "==================================================\n"

    # Expectativas para falhar o teste caso o servidor não aguente a carga
    # O ideal é que num teste real local, não haja nenhuma falha de conexão.
    expect(failure_count).to eq(0), "Ocorreram #{failure_count} falhas. O Puma pode estar rejeitando conexões. Tente aumentar a quantidade de Threads/Workers."
    
    # Tempo limite arbitrário para aceitação do teste (ajuste conforme o hardware)
    expect(time_taken).to be < 10.0, "O servidor demorou #{time_taken.round(2)}s para responder #{concurrency} requisições. O gargalo é alto."
  end
end
