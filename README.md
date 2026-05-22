# Live Wall com Ruby

O Live Wall é uma aplicação web interativa projetada para eventos, permitindo que os participantes enviem fotos e vídeos curtos que são exibidos em tempo real num mural digital. Possui um painel de administração para gestão de conteúdo e uma interface de usuário simples para o envio de arquivos.

## Funcionalidades Principais

* **Mural de Mídia em Tempo Real**: Exibe fotos e GIFs (convertidos de vídeos) enviados pelos usuários. A atualização é contínua (polling a cada 10s); se uma mídia for apagada, ela some instantaneamente da tela de todos os convidados. Existem murais estáticos (`mural.html`) e animados (`mural_animated.html`).
* **Upload de Arquivos**: Os usuários podem tirar fotos, gravar vídeos (até 10 segundos) ou escolher arquivos da galeria para enviar.
* **Conversão de Vídeo para GIF**: Os vídeos enviados são processados em segundo plano e convertidos para o formato GIF para serem exibidos no mural.
* **Painel de Administração**: Uma interface (`admin.html`) que permite visualizar todas as mídias enviadas, adicionar em lote e apagar conteúdo. Assim como os murais, o painel se atualiza em tempo real a cada 10 segundos, refletindo exclusões remotas imediatamente.
* **Exportação de Mídia**: Funcionalidade para exportar todas as fotos e GIFs processados para um arquivo .zip.

## Tecnologias Utilizadas

* **Backend**: Ruby on Rails
* **Base de Dados**: PostgreSQL
* **Frontend**: HTML5, Tailwind CSS, JavaScript (Vanilla)
* **Processamento de Vídeo**: FFmpeg
* **Jobs em Segundo Plano**: Solid Queue
* **Servidor Web**: Puma
* **Testes Automatizados**: RSpec
* **Zero Trust Networking**: ZROK

## Como Começar

### Pré-requisitos

* Ruby (versão especificada em `.ruby-version`)
* Bundler
* PostgreSQL
* ZROK [https://docs.zrok.io/docs/getting-started/](Configure seu ZROK)
* WSL [https://github.com/GiovanniRicetto/Working-Locally](Veja como montar seu ambiente local)

### Instalação Local

1. **Clone o repositório:**
    ```bash
    git clone https://github.com/giovanniricetto/livewallwithruby.git
    cd livewallwithruby
    ```

2. **Instale as dependências do sistema:**
    O FFmpeg é obrigatório para o processamento e conversão dos vídeos para GIF. No Debian/Ubuntu via WSL:
    ```bash
    sudo apt-get update
    sudo apt-get install -y ffmpeg
    ```

3. **Instale as dependências do Ruby:**
    ```bash
    bundle install
    ```

4. **Configure as permissões dos executáveis:**
    Antes de rodar os comandos do Rails, garanta que os arquivos binários têm permissão de execução:
    ```bash
    chmod +x bin/dev
    chmod +x bin/rails
    ```

5. **Configure a base de dados:**
    Certifique-se de que o PostgreSQL está rodando e execute:
    ```bash
    bin/rails db:prepare
    ```

6. **Inicie o servidor:**
    ```bash
    bin/dev
    ```
    A aplicação estará disponível em `http://localhost:3000`.

7. **Inicie ZROK para acessar fora do ambiente local**

## Estrutura do Frontend

A aplicação serve arquivos HTML estáticos a partir da pasta `public/`:

* `mural.html`: Uma grade estática que exibe todas as fotos e GIFs.
* `mural_animated.html`: Um mural animado com filas que se deslocam.
* `upload.html`: Página padrão de upload de fotos e vídeos.
* `admin.html`: O painel de administração para gestão e envio de dados em lote.

## Testes Automatizados

A aplicação possui uma suíte de testes utilizando RSpec, dividida em testes unitários, testes de contrato (API) e testes de performance.

Para rodar a suíte completa de testes unitários e de contrato:
```bash
bundle exec rspec
```

Para rodar de forma isolada apenas os testes unitários (Modelos e Controllers):
```bash
bundle exec rspec spec/models/ spec/controllers/
```

Para rodar os testes de contrato (Requests API):
```bash
bundle exec rspec spec/requests/
```

### Testes de Performance (Puma)

Existe um teste de carga específico projetado para avaliar o desempenho e a quantidade de threads/workers do Puma sob picos de acesso simultâneo (simulando polling e visualizações do evento).
Como este teste realiza conexões HTTP reais, você precisa primeiro iniciar o servidor web num terminal:
```bash
bundle exec rails server -p 3000
```
E em um segundo terminal, executar unicamente o arquivo de performance:
```bash
bundle exec rspec spec/performance/puma_load_spec.rb
```

## Documentação da API (Swagger)

O projeto possui uma documentação interativa OpenAPI/Swagger acessível pelo navegador. Todas as rotas foram mapeadas para facilitar integrações e testes rápidos:

1. Acesse `/api-docs` logo após iniciar o servidor (ex: `http://localhost:3000/api-docs`).
2. A interface visual é protegida contra CORS e permite testar interativamente os envios de fotos, vídeos e chamadas de administração (como o reset de eventos) direto do navegador.

## Endpoints da API

A API Rails fornece os seguintes endpoints:

* `GET /photos`: Lista todas as fotos.
* `POST /photos`: Cria novas fotos (Uploads simples ou em lote com limitações dinâmicas).
* `GET /photos/active_ids`: Retorna uma lista de IDs ativos para exclusão autônoma no frontend.
* `GET /videos`: Lista todos os vídeos.
* `POST /videos`: Inicia um Job de processamento de um novo vídeo.
* `GET /videos/active_ids`: Retorna uma lista de IDs de vídeos ativos.
* `DELETE /admin/photos/:id`: Apaga uma foto (via painel admin).
* `DELETE /admin/videos/:id`: Apaga um vídeo (via painel admin).
* `GET /export/download_media`: Inicia o download de um arquivo ZIP contendo todas as mídias.
