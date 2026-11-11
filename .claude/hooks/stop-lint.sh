#!/usr/bin/env bash
# Stop: antes de o agente encerrar a resposta, roda `make lint` se houve mudança em código.
#
# Se o lint falhar, sai com código 2: o Claude Code devolve a saída ao agente,
# que continua trabalhando para corrigir. Para evitar laço infinito, quando o
# agente já foi reativado por este hook (stop_hook_active=true), deixa encerrar.

set -uo pipefail

input="$(cat)"
active="$(printf '%s' "$input" | jq -r '.stop_hook_active // false' 2>/dev/null)"
[ "$active" = "true" ] && exit 0

cd "${CLAUDE_PROJECT_DIR:-.}" || exit 0
[ -f Makefile ] || exit 0
git rev-parse --is-inside-work-tree >/dev/null 2>&1 || exit 0

# Só arquivos de código alterados (ignora docs do fluxo e config do agente).
changed="$(git status --porcelain --untracked-files=all \
  | awk '{print $NF}' \
  | grep -Ev '^(\.ai/|\.claude/|\.github/)|\.md$' || true)"
[ -n "$changed" ] || exit 0

if ! output="$(make -s lint 2>&1)"; then
  {
    echo "make lint falhou. Corrija antes de encerrar:"
    echo
    printf '%s\n' "$output" | tail -n 60
  } >&2
  exit 2
fi

exit 0
