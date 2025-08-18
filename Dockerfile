# Dockerfile
# syntax=docker/dockerfile:1

# Garante que a versão do Ruby corresponde à do seu projeto
ARG RUBY_VERSION=3.3.3
FROM docker.io/library/ruby:$RUBY_VERSION-slim AS base

# A aplicação Rails vive aqui
WORKDIR /rails

# Instala as dependências base do sistema operacional
# ADICIONADO: ffmpeg para a conversão de vídeo
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y curl libjemalloc2 postgresql-client ffmpeg && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Define o ambiente de desenvolvimento como padrão
ENV RAILS_ENV="development" \
    BUNDLE_PATH="/usr/local/bundle"

# Estágio de construção para instalar as gems
FROM base AS build

# Instala as dependências necessárias para construir as gems
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential git libpq-dev libyaml-dev pkg-config && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Instala as gems da aplicação
COPY Gemfile Gemfile.lock ./
RUN bundle install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git && \
    bundle exec bootsnap precompile --gemfile

# Copia o código da aplicação
COPY . .

# Pré-compila o código da aplicação com o bootsnap para um arranque mais rápido
RUN bundle exec bootsnap precompile app/ lib/

# Estágio final da imagem
FROM base

# Copia as gems e o código da aplicação do estágio de construção
COPY --from=build "${BUNDLE_PATH}" "${BUNDLE_PATH}"
COPY --from=build /rails /rails

# Cria um utilizador não-root para executar a aplicação (boas práticas de segurança)
RUN groupadd --system --gid 1000 rails && \
    useradd rails --uid 1000 --gid 1000 --create-home --shell /bin/bash && \
    chown -R rails:rails db log storage tmp
USER 1000:1000

# O Entrypoint prepara a base de dados
ENTRYPOINT ["/rails/bin/docker-entrypoint"]

# Expõe a porta e define o comando para iniciar o servidor
EXPOSE 3000
CMD ["./bin/rails", "server", "-b", "0.0.0.0"]