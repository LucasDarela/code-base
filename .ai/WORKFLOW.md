# Fluxo de desenvolvimento orientado a specs

Este arquivo é a fonte única de verdade sobre **como** o trabalho anda neste repositório: etapas, status, IDs, arquivos e responsabilidades. Skills, agents e pessoas seguem o que está aqui. Se algo aqui contradizer uma skill, este arquivo vence e a skill deve ser corrigida.

## Visão geral

```
/bootstrap-project   (uma vez por projeto)
        │
        ▼
/create-spec  ──►  /create-plan  ──►  /implement-me  ──►  /assessment-spec
  (o quê)           (como)             (código+testes)      (validação)
                                            ▲                    │
                                            └──── FAIL (≤ 3x) ───┘
                                                                 │ PASS
                                                                 ▼
                                                           Pull Request
```

Cada etapa produz um arquivo versionado. Isso existe por dois motivos: (1) o contexto de uma sessão de IA é descartável, o arquivo não; (2) a etapa seguinte pode rodar em outra sessão, outro modelo ou outra pessoa sem depender do histórico do chat.

## Etapas

| Etapa | Skill | Modelo recomendado | Entrada | Saída | Status ao final |
| --- | --- | --- | --- | --- | --- |
| Bootstrap | `/bootstrap-project` | Opus | entrevista + código existente | `AGENTS.md`, `.ai/docs/*`, `Makefile` preenchidos | — |
| Especificar | `/create-spec` | Opus | prompt + docs + código | `.ai/specs/<slug>.md` | `Pronta para planejamento` |
| Planejar | `/create-plan` | Opus | spec + código | `.ai/plans/<slug>.md` | `Planejada` |
| Implementar | `/implement-me` | Sonnet (agent `implementer`) | spec + plano (+ assessment anterior) | código, testes, registro no plano | `Aguardando assessment` |
| Validar | `/assessment-spec` | Sonnet (agent `assessor`, só leitura) | spec + plano + diff | `.ai/assessments/<slug>.md` | `Concluída`, `Em implementação` ou `Bloqueada` |

Por que esses modelos: especificar e planejar é onde se decide **o que** fazer, e um erro ali se propaga para tudo. Implementar com plano detalhado é trabalho bem delimitado, em que o Sonnet tem ótimo custo-benefício; para specs complexas, troque o modelo do agent `implementer` para `opus`. O assessment roda em contexto isolado para não herdar os vieses de quem implementou.

## Status da spec

O campo `Status` no cabeçalho da spec segue exatamente esta máquina de estados. Nenhum outro valor é válido.

| Status | Significado | Quem define |
| --- | --- | --- |
| `Pronta para planejamento` | Spec completa, sem decisões em aberto | `/create-spec` |
| `Planejada` | Plano técnico aprovado em `.ai/plans/<slug>.md` | `/create-plan` |
| `Em implementação` | Código sendo escrito (inclusive rodadas de correção) | `/implement-me` |
| `Aguardando assessment` | Implementação terminada, falta validar | `/implement-me` |
| `Concluída` | Assessment `PASS` ou `PASS_WITH_GAPS` | `/assessment-spec` |
| `Bloqueada` | Precisa de decisão humana (3 rodadas de `FAIL`, ou ambiguidade na spec) | `/implement-me` ou `/assessment-spec` |

Transições permitidas:

```
Pronta para planejamento → Planejada → Em implementação → Aguardando assessment
Aguardando assessment → Concluída | Em implementação (FAIL, rodada < 3) | Bloqueada (FAIL, rodada = 3)
Qualquer status → Bloqueada (ambiguidade que só uma pessoa resolve)
Bloqueada → status anterior (depois que a pessoa decidir)
```

## IDs e rastreabilidade

Todo item verificável recebe um ID estável. Os IDs atravessam spec → plano → testes → assessment, e é isso que permite validar item por item em vez de "parece ok".

| Prefixo | O quê | Onde nasce |
| --- | --- | --- |
| `RF-01` | Requisito funcional | Spec, seção 7 |
| `RNF-01` | Requisito não funcional (performance, segurança, a11y) | Spec, seções 5 e 9 |
| `CA-01` | Critério de aceitação (Dado/Quando/Então) | Spec, seção 11 |
| `T-01` | Tarefa do plano | Plano |

Regras:

- IDs nunca são renumerados. Item removido fica riscado (`~~CA-04~~ removido: motivo`).
- Todo `CA` cita os `RF` que cobre. Todo `RF` tem ao menos um `CA`.
- Todo teste automatizado inclui o ID do `CA` no nome (ex.: `it("CA-03: exibe erro para e-mail inválido")`).
- O assessment avalia cada `CA` individualmente.

## Arquivos

| Caminho | Conteúdo |
| --- | --- |
| `AGENTS.md` | Contexto curto do projeto, carregado em toda sessão. Ponteiros para o resto. |
| `.ai/docs/*.md` | Conhecimento do projeto (negócio, arquitetura, regras, QA, segurança...). Lidos sob demanda. |
| `.ai/specs/<slug>.md` | O que construir. Template: `_template.md`. Exemplo: `_example-reset-password.md`. |
| `.ai/plans/<slug>.md` | Como construir + registro do que foi feito. Template: `_template.md`. Exemplo: `_example-reset-password.md`. |
| `.ai/assessments/<slug>.md` | Relatórios de validação, uma seção por rodada. Template: `_template.md`. |
| `.ai/adrs/NNNN-titulo.md` | Decisões de arquitetura do **projeto** (formato MADR). Template: `_template.md`. |

Arquivos que começam com `_` são templates ou exemplos e nunca são tratados como specs, planos ou relatórios reais.

### Onde registrar decisões

- Decisão que vale para o projeto inteiro (escolha de banco, padrão de autenticação, estrutura de pastas) → **ADR** em `.ai/adrs/`.
- Decisão tomada durante a implementação de uma spec (nome de função, ajuste de abordagem, desvio do plano) → seção **Registro de implementação** do plano.
- Na dúvida: se outra spec no futuro precisaria saber disso, é ADR.

## Ciclo de correção

1. `/assessment-spec` emite `FAIL` e lista as lacunas por ID.
2. Status volta para `Em implementação`.
3. `/implement-me <slug>` detecta o assessment com `FAIL`, corrige **só** as lacunas listadas e devolve para `Aguardando assessment`.
4. Depois de 3 rodadas com `FAIL`, o status vira `Bloqueada` e uma pessoa decide (ajustar a spec, aceitar a lacuna ou intervir no código).

O limite de 3 existe porque, se o agente não resolveu em três tentativas, o problema quase sempre está na spec ou no plano, não no código.

## Skills de terceiros

A seção 0 de cada spec lista skills que quem implementa deve carregar. Use apenas skills já disponíveis na sessão ou de fonte confiável aprovada pelo usuário. Skills são código que roda com as permissões do agente: instalar uma skill desconhecida tem o mesmo risco de instalar uma dependência desconhecida.

## Git

- Uma branch por spec: `feat/<slug>` (ou `fix/<slug>`, `chore/<slug>`).
- Commits no padrão [Conventional Commits](https://www.conventionalcommits.org/pt-br/), citando o slug: `feat(reset-password): envia e-mail de redefinição`.
- O PR usa `.github/pull_request_template.md` e linka spec, plano e assessment.
- A CI roda `make check`; PR só é mesclado com a CI verde.
