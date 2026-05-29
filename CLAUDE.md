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

## Estilo de scripts

Todos os scripts bash deste repo devem ter comentários inline suficientes para que alguém sem experiência em bash consiga ler e entender o que está acontecendo. Isso significa:

- **Comentar cada bloco lógico** dentro do script explicando o que faz e por quê
- **Explicar flags e opções não óbvias** — ex: `set -e` (para se qualquer comando falhar), `2>/dev/null` (descarta mensagens de erro), `chmod +x` (dá permissão de execução)
- **Explicar variáveis** na linha em que são definidas ou logo acima
- **Explicar pipes e substituições** — ex: `$(...)`, `|`, redirecionamentos
- Comentários em português são preferidos

---

## Segurança

- **Nunca commitar `.env`** nem arquivos com credenciais, tokens, API keys ou senhas.
- **Nunca commitar configs locais geradas** — ex: `~/.claude/settings.json` da máquina pode ter tokens de sessão.
- **Não expor dados pessoais** em scripts, comentários ou mensagens de commit (email, CPF, endereços, etc.).
- **Não adicionar**: chaves SSH, certificados, histórico de shell (`.bash_history`, `.zsh_history`), arquivos com credenciais de acesso.
- Mantenha `.gitignore` atualizado cobrindo: `*.env`, `*.pem`, `*.key`, `*secret*`, `*token*`.
