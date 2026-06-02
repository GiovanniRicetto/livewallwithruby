---
name: local-up
description: Inicia o ambiente de desenvolvimento localmente no WSL (sem Docker)
---

# `local-up` Skill

Esta skill serve para iniciar o servidor Ruby on Rails localmente, rodando no WSL e se conectando ao banco de dados PostgreSQL local.

## Pré-requisitos

1. O PostgreSQL precisa estar instalado e rodando no WSL (na porta 5432).
2. O FFmpeg precisa estar instalado para a conversão de vídeos.

## Como iniciar o ambiente

Você deve iniciar o servidor habilitando o Solid Queue no Puma para que os trabalhos em segundo plano (como a conversão de vídeos para GIF) sejam processados pela mesma instância.

Execute o comando abaixo no terminal da sua máquina WSL:

```bash
SOLID_QUEUE_IN_PUMA=true bin/dev
```

## Resolução de problemas

Se por acaso os vídeos estiverem sendo ignorados ou não se converterem em GIF, certifique-se de que nenhum servidor Docker na porta `5432` esteja ativo e impedindo a comunicação com a sua base de dados local, ou verifique se o FFmpeg está instalado localmente rodando `ffmpeg -version`.
