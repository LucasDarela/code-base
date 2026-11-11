# Code Base

Base para iniciar projetos com desenvolvimento assistido por IA: fluxo orientado a specs, contexto estruturado para agentes, portões de qualidade automáticos e rastreabilidade do requisito ao teste.

## Sobre este projeto

<!-- O /bootstrap-project substitui esta seção pelo nome e pela descrição do projeto real. -->

Este repositório é um ponto de partida. Copie-o, rode `/bootstrap-project` e comece a primeira feature com `/create-spec`.

## Começando

```bash
# 1. Copie a base para o novo projeto
cp -R code-base meu-projeto && cd meu-projeto
rm -rf .git && git init

# 2. Abra o Claude Code na pasta e configure o projeto
claude
> /bootstrap-project
```

O bootstrap entrevista você (produto, domínio, stack, qualidade, segurança) e preenche `AGENTS.md`, os docs de `.ai/docs/`, o `Makefile` e a CI.

## Fluxo de uma feature

| # | Comando | O que acontece | Resultado |
| - | ------- | -------------- | --------- |
| 1 | `/create-spec <descrição>` | Lê o projeto, levanta todas as ambiguidades e pergunta em blocos, sempre com recomendação | `.ai/specs/<slug>.md` |
| 2 | `/create-plan <slug>` | Decide o "como": contratos, tarefas pequenas, padrões de referência, cobertura por critério | `.ai/plans/<slug>.md` |
| 3 | `/implement-me <slug>` | Agent `implementer` escreve testes a partir dos critérios e depois o código | código + testes |
| 4 | `/assessment-spec <slug>` | Agent `assessor`, isolado e só leitura, valida critério por critério com evidência | `.ai/assessments/<slug>.md` |
| 5 | PR | Template linka spec, plano e assessment; CI roda `make check` | merge |

Se o assessment der `FAIL`, rode `/implement-me` de novo: ele corrige só as lacunas apontadas. Depois de 3 rodadas, a spec fica `Bloqueada` para decisão humana. Detalhes em [`.ai/WORKFLOW.md`](.ai/WORKFLOW.md).

## Estrutura

```
AGENTS.md                 Contexto curto para qualquer agente (Claude, Cursor, Codex...)
CLAUDE.md                 Importa AGENTS.md + notas do Claude Code
Makefile                  Interface única de comandos: setup, dev, format, lint, test, build, check
.env.example              Variáveis de ambiente documentadas (valores fictícios)
.claude/
  settings.json           Permissões (bloqueia .env, push --force...) e hooks
  hooks/                  Formata ao editar; roda lint antes de encerrar
  agents/                 implementer (Sonnet), assessor (Sonnet, só leitura)
  skills/                 bootstrap-project, create-spec, create-plan, implement-me, assessment-spec
.ai/
  WORKFLOW.md             Etapas, status, IDs, ciclo de correção — fonte única de verdade do fluxo
  docs/                   BUSINESS, ARCHITECTURE, RULES, QA, SECURITY, O11Y, DESIGN, DESIGN_SYSTEM
  specs/                  _template.md + _example-reset-password.md
  plans/                  _template.md + _example-reset-password.md
  assessments/            _template.md
  adrs/                   _template.md (MADR) + 0001-fluxo-orientado-a-specs.md
.github/
  workflows/ci.yml        make check em todo PR
  pull_request_template.md
```

## Princípios por trás da base

- **Contexto em camadas.** `AGENTS.md` é curto e sempre carregado; os docs são lidos sob demanda. Contexto demais dilui a atenção do modelo tanto quanto contexto de menos.
- **Prompts pedem, hooks garantem.** O que não pode falhar (formatação, lint, acesso a segredos) é aplicado por hooks, permissões e CI, não por instruções.
- **Artefatos, não conversas.** Cada etapa grava um arquivo. Qualquer etapa pode ser retomada por outra sessão, outro modelo ou outra pessoa.
- **Quem implementa não valida.** O assessment roda em contexto isolado e precisa de evidência por critério.
- **Exemplos ensinam mais que regras.** Os arquivos `_example-*` mostram o nível de detalhe esperado.
- **Rastreabilidade por ID.** `RF` → `CA` → teste (`CA-03: ...`) → assessment.

## Personalizando

- **Modelos:** troque `model:` em `.claude/agents/*.md` (ex.: `opus` no `implementer` para features complexas).
- **Comandos:** edite só o corpo dos alvos do `Makefile`; os nomes são o contrato com hooks e CI.
- **Outros agentes de IA:** `AGENTS.md` é lido nativamente por Cursor, Codex e outros. As skills são específicas do Claude Code.
