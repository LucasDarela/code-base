---
name: bootstrap-project
description: Configura esta base para um projeto novo ou existente. Lê o código (se houver), entrevista o usuário em blocos curtos e preenche AGENTS.md, os docs de .ai/docs, o Makefile e o ADR inicial de stack. Use uma vez, no início do projeto, quando o usuário invocar /bootstrap-project.
argument-hint: <descrição curta do projeto (opcional)>
disable-model-invocation: true
---

# /bootstrap-project

Esta base vem com templates vazios. Você os transforma no contexto real do projeto, para que toda sessão futura de IA comece sabendo o que é o produto, como o código é organizado e quais regras valem.

Descrição inicial: **$ARGUMENTS**

## Por que isso importa

Um agente sem contexto preenche as lacunas com o "projeto médio da internet": stack genérica, nomes genéricos, regras genéricas. Os docs de `.ai/docs/` são o que faz o agente trabalhar como alguém do time. Docs vagos produzem código vago, então vale a mesma régua da `/create-spec`: concreto, verificável, sem adjetivos soltos.

## 1. Diagnóstico (sem perguntar nada)

1. Veja se `AGENTS.md` ainda tem `bootstrap:pending`. Se não tiver, o bootstrap já rodou: pergunte se o usuário quer refazer tudo ou atualizar docs específicos.
2. Descubra se é **greenfield** (sem código) ou **brownfield** (já há código).
3. Em brownfield, levante o que o código responde: linguagem, framework, versões (manifestos e lockfiles), estrutura de pastas, ferramentas de lint, formatação e teste já configuradas, CI existente, padrões de nomes, variáveis em `.env.example`. Leia uns 3 a 5 arquivos representativos para captar convenções reais.
4. Leia todos os templates em `.ai/docs/`, além de `AGENTS.md` e `Makefile`, para saber o que precisa ser preenchido.

## 2. Entrevista

Monte a lista completa de lacunas de uma vez e pergunte com `AskUserQuestion` em **blocos de até 4 perguntas independentes**, recomendação como primeira opção (rótulo terminando em `(Recomendado)`) e `description` com o trade-off. Em brownfield, o que o código já responde vira fato, não pergunta; confirme apenas o que parecer inconsistente.

Ordem dos blocos:

1. **Produto:** o que é, para quem, problema principal, estágio (protótipo, MVP, produção), métrica de sucesso.
2. **Domínio:** entidades principais, regras de negócio críticas, termos do glossário (peça os 5 a 10 termos que mais causam confusão).
3. **Stack:** linguagem, framework, banco, hospedagem, autenticação. Em greenfield, recomende uma stack coerente com o produto e o estágio, e explique o porquê na `description`.
4. **Qualidade:** ferramentas de lint, formatação e teste; tipos de teste esperados; cobertura mínima.
5. **Segurança e dados:** dados pessoais tratados (LGPD), dados sensíveis, modelo de autorização.
6. **Observabilidade:** onde ficam logs e métricas, o que precisa de alerta.
7. **Interface** (pule se não houver): plataforma, design system ou lib de componentes, temas, idioma, público com necessidades de acessibilidade.

Antes de escrever, mostre o resumo das decisões (uma linha cada) e peça confirmação.

## 3. Preencher

Para cada arquivo, siga a estrutura do template, remova os comentários de instrução e escreva conteúdo concreto. Seção sem informação ainda fica com `A definir: <o que falta decidir e quando>`, nunca vazia.

| Arquivo | O que preencher |
| --- | --- |
| `AGENTS.md` | Projeto, stack e comandos reais. **Remova a linha `bootstrap:pending`.** Mantenha o arquivo curto (até cerca de 150 linhas): detalhe vai para os docs. |
| `Makefile` | O corpo de cada alvo com os comandos reais da stack (nunca mude os nomes dos alvos). `format` deve aceitar `FILE=`. `lint` inclui checagem de tipos quando a linguagem tiver. |
| `.ai/docs/BUSINESS.md` | Produto, personas, regras de negócio com ID (`RN-01`), glossário. |
| `.ai/docs/ARCHITECTURE.md` | Stack com versões, estrutura de pastas, camadas e dependências permitidas entre elas, integrações, padrões de referência no código. |
| `.ai/docs/RULES.md` | Convenções de código específicas do projeto (o linter já cobre o resto). |
| `.ai/docs/QA.md` | Pirâmide de testes, ferramentas, onde ficam os testes, cobertura, convenção de nome com ID do `CA`. |
| `.ai/docs/SECURITY.md` | Dados tratados, autenticação e autorização, segredos, checklist. |
| `.ai/docs/O11Y.md` | Logs, métricas, traces, alertas. |
| `.ai/docs/DESIGN.md` e `DESIGN_SYSTEM.md` | Só se houver interface. Senão, `Não se aplica: <motivo>`. |
| `.ai/adrs/0002-stack-inicial.md` | ADR da stack escolhida, a partir de `.ai/adrs/_template.md`. |
| `.gitignore` | Ajuste a seção de dependências e builds para a stack. |
| `.github/workflows/ci.yml` | Ajuste o passo de setup do runtime para a stack (a CI sempre roda `make check`). |
| `README.md` | Substitua a seção "Sobre este projeto" pelo nome e pela descrição reais. |

Em greenfield, **não** gere o scaffolding da aplicação (criar o projeto do framework e instalar dependências) sem perguntar. Ofereça como próximo passo, porque é uma ação que muda muitos arquivos.

## 4. Verificar

- Rode `make help` e `make check`. Em greenfield sem código, `make check` pode não ter o que verificar; diga isso claramente.
- Confirme que nenhum doc ficou com comentário de instrução do template, nem com seção vazia.

## 5. Entregar

Em poucas linhas: arquivos preenchidos, decisões principais, o que ficou como `A definir` e os próximos passos (scaffolding, se for greenfield; depois `/create-spec <primeira feature>`).
