---
name: docker-up
description: Inicia o ambiente de desenvolvimento (serviços web e db) usando Docker Compose.
---

# Docker Up Skill

Use esta skill quando o usuário solicitar para iniciar, subir ou rodar o ambiente de desenvolvimento via Docker.

## Instruções

1. O ambiente é composto por serviços definidos no `docker-compose.yml` na raiz do projeto (geralmente `web` e `db`).
2. Para iniciar o ambiente em modo daemon (background), execute o comando:
   `docker compose up -d`
3. Monitore se os containers subiram corretamente utilizando:
   `docker compose ps`
4. Se houver problemas com o container `web`, verifique os logs para garantir que o banco de dados e o Puma iniciaram corretamente:
   `docker compose logs web --tail 50`
