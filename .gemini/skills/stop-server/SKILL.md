---
name: stop-server
description: Encerra o servidor de desenvolvimento do Live Wall que está rodando na porta 3000.
---

# Stop Server

Esta skill garante o encerramento do servidor de desenvolvimento local.

## Instruções de Execução

Ao ser solicitado para encerrar ou parar o servidor, você deve garantir que não há processos segurando a porta padrão (`3000`), a qual o `bin/dev` (ou o Puma) utiliza.

### Passo Único: Encerrar Processos
Como utilitários de rede (como `lsof` ou `fuser`) podem não estar instalados por padrão, execute os comandos abaixo no WSL para forçar o encerramento dos processos do Rails, Puma e do bin/dev baseados em Ruby:
```bash
pkill -f puma || true
pkill -f ruby || true
```

> **Nota:** O `|| true` garante que o comando não falhará caso o servidor já esteja desligado e nenhum processo seja encontrado.
