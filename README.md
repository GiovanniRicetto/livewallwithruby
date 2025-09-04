# Live Wall com Ruby

O Live Wall é uma aplicação web interativa projetada para eventos, permitindo que os participantes enviem fotos e vídeos curtos que são exibidos em tempo real num mural digital. Possui um painel de administração para gestão de conteúdo e uma interface de utilizador simples para o envio de ficheiros.

## Funcionalidades Principais

* **Mural de Média em Tempo Real**: Exibe fotos e GIFs (convertidos de vídeos) enviados pelos utilizadores. Existem duas versões do mural: uma estática em grelha (`mural.html`) e outra com animação de scroll (`mural_animated.html`).
* **Upload de Ficheiros**: Os utilizadores podem tirar fotos, gravar vídeos (até 10 segundos) ou escolher ficheiros da sua galeria para enviar.
* **Conversão de Vídeo para GIF**: Os vídeos enviados são processados em segundo plano e convertidos para o formato GIF para serem exibidos no mural.
* **Painel de Administração**: Uma interface (`admin.html`) que permite visualizar todas as médias enviadas, adicionar novas fotos/vídeos e apagar conteúdo.
* **Exportação de Media**: Funcionalidade para exportar todas as fotos e GIFs processados para um ficheiro .zip.

## Tecnologias Utilizadas

* **Backend**: Ruby on Rails
* **Base de Dados**: PostgreSQL
* **Frontend**: HTML5, Tailwind CSS, JavaScript (sem framework)
* **Processamento de Vídeo**: FFmpeg
* **Jobs em Segundo Plano**: Solid Queue
* **Servidor Web**: Puma
* **Zero Trust Networking:**: ZROK

## Como Começar

### Pré-requisitos

* Ruby (versão especificada em `.ruby-version`)
* Bundler
* PostgreSQL
* FFmpeg
* ZROK [https://docs.zrok.io/docs/getting-started/](Configure seu ZROK)
* WSL [https://github.com/GiovanniRicetto/Working-Locally](Veja como montar seu ambiente local)

### Instalação Local

1.  **Clone o repositório:**
    ```bash
    git clone [https://github.com/giovanniricetto/livewallwithruby.git](https://github.com/giovanniricetto/livewallwithruby.git)
    cd livewallwithruby
    ```

2.  **Instale as dependências:**
    ```bash
    bundle install
    ```

3.  **Configure a base de dados:**
    Certifique-se de que o PostgreSQL está a correr e, em seguida, execute:
    ```bash
    bin/rails db:prepare
    ```

4.  **Inicie o servidor:**
    ```bash
    bin/dev
    ```
    A aplicação estará disponível em `http://localhost:3000`.

5. 

## Estrutura do Frontend

A aplicação serve ficheiros HTML estáticos a partir da pasta `public/`:

* `mural.html`: Uma grelha estática que exibe todas as fotos e GIFs.
* `mural_animated.html`: Um mural com duas filas de media que se deslocam horizontalmente.
* `upload.html`: A página de upload, onde os utilizadores podem submeter novas fotos e vídeos.
* `admin.html`: O painel de administração para gestão de conteúdo.

## Endpoints da API

A API Rails fornece os seguintes endpoints:

* `GET /photos`: Lista todas as fotos com os URLs das imagens.
* `POST /photos`: Cria uma nova foto (permite o upload de várias imagens).
* `GET /videos`: Lista todos os vídeos com os URLs dos GIFs processados.
* `POST /videos`: Cria um novo vídeo para processamento.
* `GET /admin`: Endpoint utilizado pelo painel de administração para listar todas as medias.
* `DELETE /admin/photos/:id`: Apaga uma foto.
* `DELETE /admin/videos/:id`: Apaga um vídeo.
* `GET /export/download_media`: Inicia o download de um ficheiro zip com todas as medias.