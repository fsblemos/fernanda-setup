#!/bin/bash
# Instala a config pessoal do Claude Code na máquina atual.
# Execute uma vez em cada máquina nova: bash install.sh

# set -e faz o script parar imediatamente se qualquer comando falhar,
# evitando que erros silenciosos causem problemas inesperados.
set -e

# Diretório de destino onde o Claude Code lê suas configurações.
DEST="$HOME/.claude"

# Descobre o diretório onde este script está salvo, independente de onde
# você o chama. BASH_SOURCE[0] é o caminho do próprio script; cd + pwd
# resolve para o caminho absoluto real (sem atalhos como "..").
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Verifica se o programa jq está instalado. jq é usado para ler e
# manipular arquivos JSON. "command -v" retorna sucesso se o comando
# existir; o "!" inverte: entra no if quando jq NÃO está instalado.
# &>/dev/null joga fora qualquer saída (tanto stdout quanto stderr).
if ! command -v jq &>/dev/null; then
  echo "jq not found — install it first (e.g. sudo apt install jq or brew install jq)"
  exit 1
fi

# Cria o diretório ~/.claude se ele ainda não existir.
# -p não dá erro caso o diretório já exista.
mkdir -p "$DEST"

# Copia o script da barra de status para ~/.claude/
cp "$SCRIPT_DIR/statusline-command.sh" "$DEST/statusline-command.sh"
# chmod +x dá permissão de execução ao arquivo (necessário para rodar como script).
chmod +x "$DEST/statusline-command.sh"

# Se já existe um settings.json no destino, faz merge apenas das chaves
# que este repo gerencia (statusLine e theme), preservando o resto.
if [ -f "$DEST/settings.json" ]; then
  echo "settings.json already exists — merging statusLine key only"

  # mktemp cria um arquivo temporário com nome único para não sobrescrever
  # o original enquanto ainda estamos lendo ele.
  tmp=$(mktemp)

  # jq lê o settings.json do repo e extrai só as chaves statusLine e theme.
  # --slurpfile carrega esse resultado como variável $new dentro do jq principal.
  # '. * $new[0]' faz merge: começa com o settings.json existente e sobrescreve
  # apenas as chaves de $new[0]. O resultado vai para o arquivo temporário,
  # e só então substituímos o original (mv é atômico — não deixa arquivo pela metade).
  jq --slurpfile new <(jq '{statusLine,theme}' "$SCRIPT_DIR/settings.json") \
    '. * $new[0]' "$DEST/settings.json" > "$tmp" && mv "$tmp" "$DEST/settings.json"
else
  # Primeira vez: copia o settings.json diretamente, sem merge.
  cp "$SCRIPT_DIR/settings.json" "$DEST/settings.json"
fi

echo "Done. Restart Claude Code to apply."
