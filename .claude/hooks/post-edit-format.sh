#!/usr/bin/env bash
# PostToolUse (Edit|Write|MultiEdit): formata o arquivo recém-editado via `make format FILE=...`.
#
# Nunca bloqueia: formatação é conveniência, não portão de qualidade.
# O portão é o `make lint` no hook Stop e o `make check` na CI.

set -uo pipefail

cd "${CLAUDE_PROJECT_DIR:-.}" || exit 0
[ -f Makefile ] || exit 0

file_path="$(jq -r '.tool_input.file_path // empty' 2>/dev/null)"
[ -n "$file_path" ] || exit 0
[ -f "$file_path" ] || exit 0

# Não formata documentação de fluxo nem configuração do agente.
case "$file_path" in
  */.ai/*|*/.claude/*|*.md) exit 0 ;;
esac

make -s format FILE="$file_path" >/dev/null 2>&1 || true
exit 0
