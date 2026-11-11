<!-- bootstrap:pending — remova esta linha quando /bootstrap-project preencher este arquivo. -->
# AGENTS.md

Contexto para agentes de IA (Claude Code, Cursor, Codex e outros). Este arquivo é carregado em toda sessão, então fica curto: fatos essenciais e ponteiros. O detalhe mora em `.ai/docs/` e é lido só quando a tarefa pede.

> Se a primeira linha deste arquivo ainda contém `bootstrap:pending`, o projeto não foi configurado. Antes de qualquer outra tarefa, sugira ao usuário rodar `/bootstrap-project`.

## Projeto

<!-- 2 a 4 frases: o que é, para quem, em que estágio está. Preenchido pelo /bootstrap-project. -->

## Stack

<!-- Linguagem, framework, banco, infraestrutura, com versões. Ex.: "TypeScript 5.6, Next.js 15 (App Router), PostgreSQL 16 via Drizzle". -->

## Comandos

Todos os comandos passam pelo `Makefile`, que é a interface estável entre agentes, CI e a stack real.

| Comando | O que faz |
| --- | --- |
| `make setup` | Instala dependências |
| `make dev` | Sobe o ambiente local |
| `make format` | Formata o código (aceita `FILE=caminho`) |
| `make lint` | Lint + checagem de tipos |
| `make test` | Testes automatizados |
| `make build` | Build de produção |
| `make check` | `lint` + `test` + `build`. É o que a CI roda e o que define "pronto". |

## Como trabalhar aqui

- O fluxo de features é orientado a specs: `/create-spec` → `/create-plan` → `/implement-me` → `/assessment-spec`. Regras completas, status e IDs em `.ai/WORKFLOW.md`.
- Antes de escrever código de uma feature, leia a spec e o plano dela. O que não está na spec está fora do escopo.
- Rode `make check` antes de dizer que algo está pronto. Se falhar, diga que falhou e mostre a saída.
- Decisões de arquitetura novas viram ADR em `.ai/adrs/`.

## Onde está cada coisa

Leia sob demanda, conforme a tarefa:

| Preciso de... | Leia |
| --- | --- |
| Regras de negócio, personas, glossário do domínio | `.ai/docs/BUSINESS.md` |
| Estrutura de pastas, camadas, padrões, integrações | `.ai/docs/ARCHITECTURE.md` |
| Convenções de código, nomes, proibições | `.ai/docs/RULES.md` |
| Estratégia de testes, cobertura, formatação | `.ai/docs/QA.md` |
| Segurança, segredos, autenticação, LGPD | `.ai/docs/SECURITY.md` |
| Logs, métricas, traces, alertas | `.ai/docs/O11Y.md` |
| Princípios de UX, fluxos, copy | `.ai/docs/DESIGN.md` |
| Tokens, componentes, temas | `.ai/docs/DESIGN_SYSTEM.md` |
| Decisões de arquitetura já tomadas | `.ai/adrs/` |

## Limites

- Não leia nem escreva arquivos `.env*` ou `secrets/`. Use `.env.example` para documentar variáveis.
- Não adicione dependências sem que a spec ou o plano prevejam.
- Não faça `git push --force` nem reescreva histórico compartilhado.
- Em caso de ambiguidade que mude o comportamento do produto, pergunte em vez de supor.
