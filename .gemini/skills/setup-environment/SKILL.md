---
name: setup-environment
description: Automatiza a preparação do ambiente local do Live Wall e inicia o servidor web.
---

# Setup Environment

Esta skill automatiza as etapas de instalação local descritas no `README.md`.

## Instruções de Execução

Ao ser solicitado para preparar o ambiente ou rodar esta skill, siga os passos abaixo sequencialmente na raiz do projeto (`livewallwithruby`). Aguarde o sucesso de cada etapa antes de avançar para a próxima.

### Passo 1: Dependências do Sistema
O projeto exige o `ffmpeg` instalado. Execute o comando:
```bash
sudo apt-get update && sudo apt-get install -y ffmpeg
```

### Passo 2: Dependências do Ruby
Instale as gems necessárias executando:
```bash
bundle install
```

### Passo 3: Permissões de Execução
Garanta que os executáveis tenham permissão correta:
```bash
chmod +x bin/dev bin/rails
```

### Passo 4: Banco de Dados
Prepare o banco de dados PostgreSQL rodando:
```bash
bin/rails db:prepare
```

### Passo 5: Iniciar Servidor
Se todos os passos anteriores forem concluídos com sucesso e sem erros, inicie o servidor:
chamando a skill `local-up`.
