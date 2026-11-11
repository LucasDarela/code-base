---
name: assessment-spec
description: Valida se uma implementação cumpre a spec, critério por critério, delegando ao agent assessor (contexto isolado, somente leitura). Grava o relatório em .ai/assessments e atualiza o status. Use quando o usuário invocar /assessment-spec ou pedir para validar ou aceitar uma spec implementada.
argument-hint: <slug ou caminho da spec>
disable-model-invocation: true
---

# /assessment-spec

Você orquestra a validação. A análise é feita pelo agent **`assessor`**, em contexto isolado, para que o veredito não herde as suposições de quem implementou. Você grava o relatório e atualiza o status; não corrige código.

Argumento: **$ARGUMENTS**. Se estiver vazio, liste as specs com status `Aguardando assessment` e pergunte qual validar.

## 1. Resolver e conferir

- Resolva o slug como em `/implement-me`.
- Precisam existir `.ai/specs/<slug>.md` e `.ai/plans/<slug>.md`.
- O status esperado é `Aguardando assessment`. Se for outro, avise e pergunte se quer validar mesmo assim (útil para auditar uma spec antiga).

## 2. Definir a rodada

Se `.ai/assessments/<slug>.md` existe, a rodada é o número da última + 1. Senão, é a rodada 1 e o arquivo será criado a partir de `.ai/assessments/_template.md`.

## 3. Delegar

Chame o agent `assessor` com o slug e o número da rodada. Ele devolve a seção da rodada já preenchida.

## 4. Gravar o relatório

- Rodada 1: crie `.ai/assessments/<slug>.md` com o cabeçalho do template e a seção devolvida.
- Rodadas seguintes: acrescente a nova seção no fim do arquivo e atualize o campo `Veredito atual` do cabeçalho.

Grave exatamente o que o assessor devolveu. Se discordar de algo, não edite o veredito: diga ao usuário o que você questiona e por quê.

## 5. Atualizar o status da spec

| Veredito | Novo status | Próximo passo sugerido |
| --- | --- | --- |
| `PASS` | `Concluída` | Abrir PR com `.github/pull_request_template.md` |
| `PASS_WITH_GAPS` | `Concluída` | Abrir PR; listar as lacunas no PR. Se alguma lacuna merecer trabalho, sugerir uma nova spec. |
| `FAIL`, rodada < 3 | `Em implementação` | `/implement-me <slug>` (corrige só as lacunas) |
| `FAIL`, rodada = 3 | `Bloqueada` | Decisão humana: ajustar spec/plano, aceitar a lacuna ou intervir no código |

## 6. Responder

Em poucas linhas: veredito, rodada, contagem de `CA` (✅/❌/⚠️), as lacunas bloqueantes (uma linha cada, com ID) e o próximo passo. O relatório completo fica no arquivo; não cole tudo no chat.
