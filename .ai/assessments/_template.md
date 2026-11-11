# Assessment: [Nome da feature]

> **Spec:** `.ai/specs/<slug>.md`
> **Plano:** `.ai/plans/<slug>.md`
> **Veredito atual:** PASS | PASS_WITH_GAPS | FAIL

<!--
O cabeçalho acima é criado na rodada 1 e só o "Veredito atual" muda depois.
Cada execução de /assessment-spec acrescenta uma seção "Rodada N" no fim do arquivo.
O agent assessor devolve exatamente a seção abaixo, preenchida.
-->

---

## Rodada N — AAAA-MM-DD

**Veredito:** PASS | PASS_WITH_GAPS | FAIL
**Resumo:** <uma ou duas frases>

### Verificações objetivas

| Comando | Resultado | Observação |
| ------- | --------- | ---------- |
| `make lint` | ✅ / ❌ | |
| `make test` | ✅ / ❌ | <n testes, n falhas> |
| `make build` | ✅ / ❌ | |

### Critérios de aceitação

| CA | Status | Evidência |
| -- | ------ | --------- |
| CA-01 | ✅ / ❌ / ⚠️ | <teste `nome` em `arquivo:linha`, ou trecho de código> |

### Requisitos, escopo e restrições

| Item | Status | Evidência |
| ---- | ------ | --------- |
| RF-01 (copy literal) | ✅ / ❌ | |
| Escopo: nada fora da spec | ✅ / ❌ | |
| Restrições (seção 5) e RULES.md | ✅ / ❌ | |
| Plano: tarefas concluídas e desvios registrados | ✅ / ❌ | |
| Segurança | ✅ / ❌ | |

### Lacunas

<!-- Só para FAIL e PASS_WITH_GAPS. Cada lacuna precisa ser corrigível sem perguntas. -->

| # | ID | Bloqueante | O que está errado | Evidência | O que precisa acontecer |
| - | -- | ---------- | ----------------- | --------- | ----------------------- |
| 1 | CA-03 | sim | | | |

### Rodadas anteriores

<!-- A partir da rodada 2: para cada lacuna da rodada anterior, "resolvida" ou "persiste". -->
