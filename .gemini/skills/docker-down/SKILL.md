---
name: docker-down
description: Desliga e remove os containers do ambiente de desenvolvimento (serviços web e db) usando Docker Compose.
---

# Docker Down Skill

Use esta skill quando o usuário solicitar para parar, desligar ou derrubar o ambiente de desenvolvimento via Docker.

## Instruções

1. Para desligar o ambiente e remover os containers de forma segura, execute o comando:
   `docker compose down`
2. Isso garantirá que o banco de dados (`db`) e o servidor (`web`) sejam interrompidos corretamente sem corromper dados, desde que os volumes mapeados permaneçam intactos.
3. Se o usuário quiser remover também os volumes (ex: limpar o banco de dados), você deve avisá-lo das consequências antes de usar a flag `-v` (`docker compose down -v`).
