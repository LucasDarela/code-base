# 0001. Desenvolver features com fluxo orientado a specs e agentes de IA

> **Status:** Aceito
> **Data:** 2026-11-11
> **Origem:** base de código inicial

## Contexto

Agentes de IA escrevem código rápido, mas preenchem lacunas com suposições. Pedidos em linguagem natural ("faz uma tela de login") deixam dezenas de decisões implícitas, e cada uma vira um ponto de divergência entre o que a pessoa imaginou e o que foi entregue. Além disso, o contexto de uma sessão de chat se perde: decisões tomadas numa conversa não chegam à próxima.

Também é preciso separar quem decide de quem executa e de quem valida, para que erros de interpretação apareçam antes do merge e não em produção.

## Opções consideradas

1. **Prompt direto para o agente**: rápido para tarefas pequenas, mas sem rastreabilidade e com alta taxa de retrabalho em features médias.
2. **Spec única, implementada e validada na mesma sessão**: melhor, mas quem valida herda as suposições de quem implementou.
3. **Fluxo em etapas com artefatos versionados**: spec → plano → implementação → assessment independente, cada etapa num arquivo em `.ai/`.

## Decisão

Adotamos a opção 3, descrita em `.ai/WORKFLOW.md`:

- A spec elimina ambiguidade antes do código, com perguntas ao usuário e critérios de aceitação verificáveis (`CA-xx`).
- O plano concentra as decisões técnicas num modelo mais forte, para que a implementação seja execução e não interpretação.
- A implementação começa pelos testes derivados dos `CA`.
- O assessment roda em contexto isolado e somente leitura, avaliando cada `CA` com evidência.
- Hooks e CI garantem o que não pode depender do modelo lembrar (formatação, lint, `make check`).

## Consequências

### Positivas

- Rastreabilidade de ponta a ponta por ID (RF → CA → teste → assessment).
- Qualquer etapa pode ser retomada em outra sessão, outro modelo ou outra pessoa.
- Erros de interpretação aparecem na spec, onde corrigir é barato.

### Negativas

- Mais cerimônia para mudanças muito pequenas. Para correções triviais (typo, ajuste de uma linha), dispensar o fluxo é aceitável, desde que `make check` passe.
- Exige manter os docs de `.ai/docs/` atualizados; docs desatualizados degradam todas as etapas.

### O que muda para quem desenvolve

- Feature nova começa por `/create-spec`, não por código.
- Comandos de qualidade passam sempre pelo `Makefile`.
- PRs de feature linkam spec, plano e assessment.
