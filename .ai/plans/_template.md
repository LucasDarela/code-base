# Plano: [Nome da feature]

> **Spec:** `.ai/specs/<slug>.md`
> **Criado em:** AAAA-MM-DD
> **ADRs relacionados:** `.ai/adrs/NNNN-titulo.md` (ou "nenhum")

<!--
Gerado por /create-plan, executado pelo agent implementer. Exemplo completo em _example-reset-password.md.
O plano decide o COMO. Nenhuma tarefa deve exigir decisão de arquitetura de quem implementa.
Remova os comentários HTML ao finalizar.
-->

## 1. Abordagem

<!-- 3 a 8 linhas: a solução em visão geral e por que ela, e não as alternativas óbvias. -->

## 2. Contratos

<!-- Assinaturas, tipos, rotas, payloads, esquema de dados. Em código, não em prosa. -->

## 3. Dependências novas

<!-- Nome, versão e motivo, ou "Nenhuma". -->

## 4. Tarefas

<!--
Uma tarefa = uma unidade testável que deixa o projeto compilando.
Referência = arquivo existente cujo padrão deve ser seguido (caminho:linha).
-->

- [ ] **T-01 — [título]**
  - Arquivos: `criar caminho/arquivo` · `alterar caminho/outro`
  - O que fazer:
  - Referência: `caminho:linha`
  - Cobre: CA-01, CA-02
  - Verificar: `make test` (ou comando específico)

## 5. Matriz de cobertura

| CA | Tarefa | Tipo de teste | Arquivo de teste |
| -- | ------ | ------------- | ---------------- |
| CA-01 | T-01 | unitário / integração / e2e / manual |  |

## 6. Riscos e mitigação

| Risco | Mitigação |
| ----- | --------- |

## 7. Registro de implementação

<!-- Preenchido pelo implementer ao final. Não preencha ao criar o plano. -->

### Arquivos criados e alterados

### Desvios do plano

### Decisões durante a implementação

### CA sem teste automatizado
