---
name: local-down
description: Interrompe e limpa a execução do servidor local no WSL.
---

# `local-down` Skill

Esta skill descreve como encerrar corretamente a execução do servidor Ruby on Rails que foi iniciado localmente (via WSL).

## Parada Padrão

A forma mais recomendada de encerrar o servidor é utilizando o atalho do teclado diretamente no terminal onde o `SOLID_QUEUE_IN_PUMA=true bin/dev` está rodando:

1. Vá até o terminal em que o servidor está rodando.
2. Pressione **`Ctrl + C`**.
3. Aguarde o Puma e o Solid Queue encerrarem os processos graciosamente.

## Parada Forçada (Caso o servidor trave ou a porta 3000 fique em uso)

Se por algum motivo você perdeu o terminal, a aplicação travou e a porta `3000` continua em uso, você pode forçar o encerramento do processo do servidor executando os comandos abaixo no seu WSL:

```bash
# Tenta encerrar o processo listado no arquivo PID do servidor
kill -9 $(cat tmp/pids/server.pid) 2>/dev/null

# Limpa o arquivo de PID do Rails para a próxima inicialização
rm -f tmp/pids/server.pid

# Caso existam outros processos perdidos do Puma ou Solid Queue, encerra forçadamente:
pkill -f puma
pkill -f solid_queue
```

Isso garante que todas as threads de conversão (FFmpeg) e do servidor web (Puma) rodando na sua máquina host sejam finalizadas com segurança.
