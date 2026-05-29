# fernanda-setup

Setup pessoal para bootstrapar uma máquina nova. Com o tempo acumula configs, scripts e ferramentas úteis.

## Estrutura

O repo cresce por categorias à medida que novas configs são adicionadas. Hoje:

| Arquivo | Propósito |
|---|---|
| `install.sh` | Script de instalação do Claude Code config |
| `settings.json` | Configurações base do Claude Code (tema, statusLine) |
| `statusline-command.sh` | Script da barra de status do Claude Code |

## Comandos

### `bash install.sh`

Instala a config do Claude Code em `~/.claude/`.

- Copia `statusline-command.sh` para `~/.claude/` com permissão de execução
- Faz merge das chaves `statusLine` e `theme` no `settings.json` existente, ou copia do zero

**Pré-requisito:** `jq` instalado (`sudo apt install jq` ou `brew install jq`).

---

## Segurança

- **Nunca commitar `.env`** nem arquivos com credenciais, tokens, API keys ou senhas.
- **Nunca commitar configs locais geradas** — ex: `~/.claude/settings.json` da máquina pode ter tokens de sessão.
- **Não expor dados pessoais** em scripts, comentários ou mensagens de commit (email, CPF, endereços, etc.).
- **Não adicionar**: chaves SSH, certificados, histórico de shell (`.bash_history`, `.zsh_history`), arquivos com credenciais de acesso.
- Mantenha `.gitignore` atualizado cobrindo: `*.env`, `*.pem`, `*.key`, `*secret*`, `*token*`.
