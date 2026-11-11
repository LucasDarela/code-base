---
name: implement-me
description: Implementa uma spec já planejada delegando ao agent implementer (testes a partir dos critérios de aceitação, depois código). Também roda as rodadas de correção após um assessment FAIL. Use quando o usuário invocar /implement-me ou pedir para implementar uma spec pronta.
argument-hint: <slug ou caminho da spec>
disable-model-invocation: true
---

# /implement-me

Você orquestra a implementação: confere as pré-condições, delega o código ao agent **`implementer`**, faz a ponte com o usuário quando ele travar e atualiza o status. Quem escreve código é o agent; você não escreve código de produto aqui.

Argumento: **$ARGUMENTS** (ex.: `reset-password` ou `.ai/specs/reset-password.md`). Se estiver vazio, liste as specs com status `Planejada` ou `Em implementação` e pergunte qual implementar.

## 1. Resolver o slug

- Caminho `.ai/specs/<slug>.md` → use `<slug>`.
- Só o nome → normalize para kebab-case, sem `.md`.

## 2. Conferir pré-condições

| Verificação | Se falhar |
| --- | --- |
| `.ai/specs/<slug>.md` existe | Pare: "Spec não encontrada. Rode `/create-spec`." |
| `.ai/plans/<slug>.md` existe | Pare: "Falta o plano em `.ai/plans/<slug>.md`. Rode `/create-plan <slug>`." |
| Status da spec é `Planejada` ou `Em implementação` | Se `Pronta para planejamento`: peça `/create-plan`. Se `Aguardando assessment`: sugira `/assessment-spec`. Se `Concluída`: pergunte se quer reabrir (vira uma nova spec ou um ajuste explícito). Se `Bloqueada`: mostre o motivo registrado e pergunte como seguir. |
| Árvore git sem mudanças alheias à spec | Mostre `git status` e pergunte se pode seguir assim. Mudanças misturadas atrapalham o assessment. |

Não invente o plano nem siga sem ele: o plano é o que permite ao implementer trabalhar sem reinterpretar a spec.

## 3. Definir o modo

- Se `.ai/assessments/<slug>.md` existe e a última rodada é `FAIL`: modo **`correção`**. Conte as rodadas com `FAIL`. Se já forem 3, não delegue: mude o status para `Bloqueada`, explique que o problema provavelmente está na spec ou no plano (veja `.ai/WORKFLOW.md`, "Ciclo de correção") e pergunte ao usuário como seguir.
- Caso contrário: modo **`inicial`**. Sugira criar a branch `feat/<slug>` se ainda estiver na branch principal.

## 4. Delegar

1. Atualize o cabeçalho da spec: `Status: Em implementação`.
2. Chame o agent `implementer` com: caminho da spec, caminho do plano, modo e, no modo `correção`, a lista de lacunas da última rodada copiada do assessment.

## 5. Tratar o retorno

| `RESULTADO` | O que fazer |
| --- | --- |
| `OK` | Siga para o passo 6. |
| `BLOQUEADO` | Leve as `PERGUNTAS` ao usuário com `AskUserQuestion` (recomendação do agent como primeira opção). Se a resposta mudar a spec, a mudança é do usuário: mostre o trecho a alterar, peça confirmação, edite a spec e registre na seção 14. Depois delegue de novo, retomando de onde parou. |
| `FALHOU` | Mostre ao usuário o que falhou (com a saída de `make check`) e pergunte: tentar de novo, ajustar o plano ou parar. Não diga que terminou. |

## 6. Fechar

1. Confira você mesmo que o **Registro de implementação** do plano foi preenchido e que `make check` passa (rode o comando).
2. Atualize a spec: `Status: Aguardando assessment`.
3. Responda ao usuário em poucas linhas: tarefas concluídas, arquivos tocados, `CA` sem teste automatizado (se houver), desvios do plano, sugestões fora do escopo e o próximo passo: `/assessment-spec <slug>`.
