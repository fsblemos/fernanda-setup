#!/bin/bash
# Gera a linha de status customizada do Claude Code.
# O Claude Code chama este script automaticamente e passa um JSON via stdin
# com informações da sessão (modelo ativo, diretório, uso de contexto, etc.).
# O script lê esse JSON e imprime uma linha formatada para aparecer na interface.

# Lê todo o stdin de uma vez e salva num arquivo temporário.
# Isso é necessário porque vários comandos jq vão ler os mesmos dados —
# stdin só pode ser lido uma vez, então salvamos antes de processar.
# mktemp cria um arquivo com nome único para evitar conflitos.
tmpfile=$(mktemp /tmp/claude-statusline.XXXXXX)

# trap garante que o arquivo temporário seja deletado quando o script terminar,
# mesmo que ocorra um erro. EXIT é o sinal disparado ao sair do script.
trap 'rm -f "$tmpfile"' EXIT

# Salva todo o conteúdo do stdin no arquivo temporário.
cat > "$tmpfile"

# Captura o nome do usuário atual e o nome curto da máquina (sem domínio).
user=$(whoami)
host=$(hostname -s)

# Extrai campos do JSON usando jq.
# -r retorna o valor sem aspas (raw).
# // empty: se o campo não existir no JSON, retorna vazio em vez de "null".
cwd=$(jq -r '.workspace.current_dir // empty' "$tmpfile")
model=$(jq -r '.model.display_name // empty' "$tmpfile")

# used_percentage é um número de 0 a 100 que o Claude Code já calcula.
# O if dentro do jq verifica se o campo existe e não é null antes de retornar.
# | tostring converte o número para texto, já que o shell trabalha com strings.
used=$(jq -r 'if .context_window.used_percentage != null then (.context_window.used_percentage | tostring) else empty end' "$tmpfile")

# Imprime user@host:cwd com cores no estilo do terminal Linux (igual ao PS1 do bash).
# \033[ inicia uma sequência de cor ANSI; 01;32m = negrito verde; 00m = reset.
# %s é o placeholder para string no printf (equivale ao {} de outras linguagens).
printf "\033[01;32m%s@%s\033[00m:\033[01;34m%s\033[00m" "$user" "$host" "$cwd"

# Mostra o nome do modelo entre colchetes, mas só se o valor existir.
# -n verifica se a string não está vazia.
if [ -n "$model" ]; then
  printf "  [%s]" "$model"
fi

# Mostra o percentual de uso do context window com cor progressiva.
if [ -n "$used" ]; then
  # printf "%.0f" arredonda o número para inteiro (ex: 79.6 → 80).
  used_int=$(printf "%.0f" "$used")

  # Escolhe a cor com base no percentual: verde até 59%, amarelo até 79%, vermelho acima.
  if [ "$used_int" -ge 80 ]; then
    ctx_color="\033[01;31m"  # negrito vermelho
  elif [ "$used_int" -ge 60 ]; then
    ctx_color="\033[01;33m"  # negrito amarelo/laranja
  else
    ctx_color="\033[01;32m"  # negrito verde
  fi

  # %% no printf vira um % literal (% sozinho seria interpretado como formato).
  printf "  ${ctx_color}ctx: %s%% used\033[00m" "$used_int"
fi
