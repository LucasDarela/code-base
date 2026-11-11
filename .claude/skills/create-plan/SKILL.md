---
name: create-plan
description: Gera o plano técnico de implementação (.ai/plans/<slug>.md) de uma spec pronta, com tarefas pequenas e ordenadas, cada uma ligada aos critérios de aceitação que cobre. Use quando o usuário invocar /create-plan ou pedir para planejar uma spec.
argument-hint: <slug ou caminho da spec>
disable-model-invocation: true
---

# /create-plan

A spec diz **o quê**; o plano diz **como**. Você lê a spec e o código e escreve um plano tão concreto que o agent `implementer` consiga executar tarefa por tarefa sem tomar decisões de arquitetura.

Por que separar spec de plano: o usuário aprova o comportamento (spec) sem precisar ler detalhes técnicos, e o implementer recebe decisões técnicas já tomadas por um modelo mais forte, em vez de improvisar no meio do código.

Argumento: **$ARGUMENTS**. Se estiver vazio, liste as specs com status `Pronta para planejamento` e pergunte qual planejar.

## 1. Pré-condições

- Resolva o slug (como em `/implement-me`) e confirme que `.ai/specs/<slug>.md` existe.
- O status deve ser `Pronta para planejamento`. Se for `Planejada` e já houver plano, pergunte se quer refazer. Outros status: avise e pare.
- Se a spec tiver qualquer decisão em aberto na seção 14, pare e sugira resolver com `/create-spec` (atualizar a existente).

## 2. Coletar contexto

Leia:

1. `.ai/WORKFLOW.md`, `.ai/plans/_template.md` e `.ai/plans/_example-reset-password.md` (nível de detalhe esperado).
2. A spec inteira.
3. `AGENTS.md`, `.ai/docs/ARCHITECTURE.md`, `RULES.md`, `QA.md`, `SECURITY.md` e os ADRs em `.ai/adrs/`.
4. O código que a feature toca e **pelo menos um exemplo existente de cada padrão** que você vai mandar seguir (ex.: um endpoint parecido, um componente parecido, um teste parecido). Planos que citam padrões reais do repositório são seguidos; planos genéricos são reinterpretados.
5. A documentação das libs envolvidas, na versão instalada, quando houver dúvida sobre a API.

## 3. Decidir

Antes de escrever, resolva as decisões técnicas: onde cada responsabilidade mora, contratos (tipos, assinaturas, rotas, esquema de dados), estratégia de testes por `CA`, migrações, riscos.

Pergunte ao usuário (com `AskUserQuestion`, em blocos de até 4, recomendação primeiro) **apenas** decisões técnicas com trade-off real que o repositório e os ADRs não resolvem, como adicionar uma dependência nova ou mudar um padrão existente. O resto você decide e justifica no plano.

Se uma decisão valer para o projeto inteiro (não só esta feature), crie um ADR em `.ai/adrs/` a partir de `_template.md` e cite-o no plano.

Se descobrir que a spec é inviável ou contradiz o código, não contorne em silêncio: mostre o conflito ao usuário e sugira o ajuste na spec.

## 4. Escrever o plano

Crie `.ai/plans/<slug>.md` seguindo `_template.md`:

- **Tarefas pequenas** (`T-01`, `T-02`...), cada uma completável e testável isoladamente, idealmente tocando poucos arquivos. Ordene de forma que o projeto continue compilando entre uma tarefa e outra.
- Cada tarefa lista: arquivos (criar/alterar), o que fazer, o padrão de referência no repositório (`caminho:linha`), os `CA` que cobre e como verificar.
- **Matriz de cobertura:** todo `CA` da spec aparece em pelo menos uma tarefa, com o tipo de teste (unitário, integração, e2e, manual).
- Contratos escritos de forma concreta (assinaturas, tipos, formato de payload), não em prosa.
- Deixe a seção **Registro de implementação** vazia: quem preenche é o implementer.

## 5. Auto-revisão

- [ ] Todo `CA` está na matriz de cobertura.
- [ ] Nenhuma tarefa exige decisão de arquitetura do implementer.
- [ ] Todo caminho de arquivo existe (para alterar) ou tem pasta coerente com `ARCHITECTURE.md` (para criar).
- [ ] Toda dependência nova está listada com versão e foi aprovada.
- [ ] Nada no plano amplia o escopo da spec.
- [ ] Nenhum `TODO`, `TBD` ou `...`.

## 6. Fechar

1. Atualize a spec: `Status: Planejada`.
2. Responda em poucas linhas: caminho do plano, número de tarefas, decisões técnicas principais, ADRs criados e o próximo passo: `/implement-me <slug>`.
