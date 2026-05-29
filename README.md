# fernanda-setup

Setup pessoal para configurar uma máquina nova do zero. Clone este repo e siga os passos abaixo.

> Sistemas suportados: Linux, WSL (Windows) e macOS.

---

## 1. Instalar dependências básicas

Antes de qualquer coisa, garanta que as ferramentas essenciais estão instaladas.

**Linux / WSL:**
```bash
sudo apt update && sudo apt install -y git curl jq
```

**macOS:**
```bash
# Instala o Homebrew (gerenciador de pacotes do Mac), se ainda não tiver
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

brew install git curl jq
```

---

## 2. Clonar este repositório

```bash
git clone https://github.com/fsblemos/fernanda-setup.git ~/fernanda-setup
```

---

## 3. Configurar o Claude Code

Copia os arquivos de configuração do Claude Code para `~/.claude/`.

```bash
bash ~/fernanda-setup/install.sh
```

O que este script faz:
- Copia o script da barra de status customizada para `~/.claude/`
- Aplica as configurações de tema e statusLine no `~/.claude/settings.json`

> Após rodar, reinicie o Claude Code para aplicar as mudanças.

---

## Estrutura do repo

```
fernanda-setup/
├── install.sh               # Script de instalação do Claude Code config
├── settings.json            # Configurações base do Claude Code (tema, statusLine)
├── statusline-command.sh    # Script da barra de status do Claude Code
├── README.md                # Este arquivo
└── CLAUDE.md                # Instruções para o Claude Code ao trabalhar neste repo
```

---

## Adicionando novos setups

Este repo cresce com o tempo. Ao adicionar uma nova ferramenta ou config:

1. Crie um script ou arquivo de config na pasta correspondente
2. Documente o passo no README (nesta seção, com número sequencial)
3. Adicione comentários detalhados dentro do script — veja `CLAUDE.md` para o padrão
