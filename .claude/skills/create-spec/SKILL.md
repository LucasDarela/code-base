---
name: create-spec
description: Cria uma spec completa e sem ambiguidade em .ai/specs a partir de uma descrição de feature. Lê o projeto, levanta todas as lacunas de uma vez, pergunta ao usuário em blocos curtos (sempre com recomendação) e só escreve quando não sobra nenhuma decisão em aberto. Use quando o usuário invocar /create-spec ou pedir para especificar uma feature.
argument-hint: <descrição da feature>
disable-model-invocation: true
---

# /create-spec

Transforme a descrição do usuário numa spec em `.ai/specs/<slug>.md` que qualquer pessoa ou agente consiga implementar sem precisar perguntar nada.

Descrição do usuário: **$ARGUMENTS**

Se a descrição estiver vazia, pergunte em texto simples qual feature especificar e espere a resposta.

## Por que esta skill funciona assim

Uma spec boa elimina os pontos em que duas pessoas implementariam de jeitos diferentes. Cada ambiguidade que sobra vira uma suposição do agente que implementa, e suposição errada vira retrabalho. Por isso:

- **Você lê antes de perguntar.** O tempo do usuário é o recurso mais caro deste fluxo. Pergunte só o que o repositório não responde.
- **Você analisa tudo antes da primeira pergunta.** Perguntas feitas aos poucos, com reanálise entre elas, fazem o usuário responder coisas que depois se contradizem.
- **Toda pergunta traz sua recomendação.** O usuário decide mais rápido corrigindo uma proposta do que criando do zero.
- **Nada é escrito antes de fechar as decisões.** Uma spec parcial parece pronta e acaba sendo implementada.

Você não implementa a feature. Tudo é escrito em português do Brasil.

## Passo 1 — Coletar contexto (sem perguntar nada)

Leia, nesta ordem:

1. `.ai/WORKFLOW.md`: status, IDs e convenções do fluxo.
2. `.ai/specs/_template.md`: a estrutura obrigatória.
3. `.ai/specs/_example-reset-password.md`: o **nível de detalhe esperado**. Sua spec deve ser tão concreta quanto este exemplo.
4. As specs reais em `.ai/specs/` (arquivos que não começam com `_`): consistência de nomes, copy, padrões e decisões já tomadas.
5. `AGENTS.md` e os docs de `.ai/docs/`, principalmente `BUSINESS.md` (regras e glossário), `ARCHITECTURE.md` (stack e estrutura), `RULES.md`, `DESIGN.md` e `SECURITY.md`.
6. Os arquivos de configuração que o `ARCHITECTURE.md` indicar (manifesto de dependências, config do framework, tokens de tema) e o código que a feature toca.
7. **Skills relevantes:** veja as skills disponíveis na sessão e escolha as que se aplicam aos domínios da feature (UI, framework, banco, testes...). Para cada uma, anote o nome e para que serve nesta entrega. Não sugira instalar skill de fonte desconhecida (motivo em `.ai/WORKFLOW.md`, seção "Skills de terceiros").

Se `AGENTS.md` ainda tiver `bootstrap:pending` na primeira linha, avise o usuário que os docs do projeto estão vazios e recomende rodar `/bootstrap-project` antes. Siga só se ele confirmar.

Defina o slug em kebab-case (ex.: `reset-password`). Se `.ai/specs/<slug>.md` já existir, a primeira pergunta é: sobrescrever, atualizar a existente ou usar outro nome.

## Passo 2 — Análise completa

Percorra cada seção do template e a checklist abaixo e levante **todas** as lacunas de uma vez. Lacuna é qualquer ponto em que duas pessoas poderiam implementar de jeitos diferentes.

- **Contexto e objetivo:** para quem, que problema resolve, qual resultado verificável desta entrega.
- **Estado atual:** o que existe no código e o destino de cada parte (manter, alterar, remover).
- **Tecnologias:** libs novas e existentes, versões.
- **Restrições:** o que é proibido (técnico, produto, arquitetura).
- **Escopo:** cada item em "incluso" ou "não incluso". Nada implícito.
- **Funcional:** cada campo (nome, tipo, obrigatoriedade, formato, limites, normalização como trim), cada regra, cada **mensagem exata**, cada estado (vazio, carregando, sucesso, erro, desabilitado) e o que acontece depois de cada ação.
- **Casos de borda:** entrada inválida, duplo clique, concorrência, valores extremos, sem permissão, sem dados, falha de rede ou de serviço externo.
- **Não funcionais:** desempenho, segurança (autorização, dados sensíveis, rate limit), observabilidade (que eventos logar), LGPD.
- **UI/UX** (só se a feature tiver interface): layout, componentes, **copy exata**, breakpoints, temas, estados visuais.
- **Acessibilidade** (só se tiver interface): requisitos verificáveis com WCAG 2.2 AA como base.
- **Aceitação e QA:** cenários verificáveis com resultado esperado.
- **Skills:** quais das skills encontradas serão obrigatórias na implementação.

Lacunas de baixo impacto que seguem um padrão claro do projeto ou de specs anteriores podem ser resolvidas sem perguntar. Guarde essas decisões para mostrar no Passo 4.

Com as lacunas restantes, monte internamente a lista de perguntas:

- Ordene por impacto: escopo e objetivo primeiro (mudam todo o resto), depois regras funcionais, depois UI, acessibilidade e detalhes.
- Anote dependências: "pular se a resposta da [2] for 'sem back-end'".
- Garanta que a recomendação de cada pergunta seja coerente com as recomendações das anteriores.
- Agrupe em **blocos de até 4 perguntas independentes entre si**, preferindo o mesmo tema. Pergunta que depende de outra vai para um bloco posterior.

Se a lista passar de 16 perguntas, provavelmente a feature é grande demais para uma spec. Antes de perguntar o resto, pergunte se o usuário quer dividir em specs menores e sugira a divisão.

## Passo 3 — Elicitação em blocos

Percorra os blocos na ordem. Cada bloco é **uma** chamada de `AskUserQuestion` com 1 a 4 perguntas. Para cada pergunta:

- `header`: o tema, com até 12 caracteres (ex.: "Escopo", "Validação", "Copy").
- `question`: objetiva, terminando com `?`, começando pelo número global (ex.: `[5] Qual mensagem mostrar quando o e-mail for inválido?`).
- **Primeira opção = sua recomendação**, com o rótulo terminando em `(Recomendado)`.
- De 1 a 3 alternativas realistas e diferentes entre si. A opção "Outro" já vem na ferramenta; não crie uma.
- `description` em cada opção, com a consequência ou o trade-off. Quando a sugestão vier do repositório, cite a fonte (ex.: "padrão usado em `.ai/specs/sign-up.md`").
- `preview` quando comparar código, layout ou textos.
- `multiSelect: true` para a escolha de skills.

Entre um bloco e outro, não refaça a análise nem leia código. Pule perguntas cuja condição deixou de valer e ajuste o texto de uma pergunta só se uma resposta anterior a tornou incorreta.

Respostas em "Outro" que ainda tenham ambiguidade (ex.: "uma mensagem amigável") não interrompem a sequência: anote-as. No fim, se houver respostas assim ou lacunas novas criadas pelas respostas, monte um bloco curto de acompanhamento e percorra-o do mesmo jeito.

## Passo 4 — Confirmar antes de escrever

1. Mostre um resumo curto das decisões, uma linha por decisão, separando "respondidas por você" e "assumidas por mim (padrão do projeto)".
2. Pergunte com `AskUserQuestion`: `Posso escrever a spec com essas decisões?`, com as opções `Sim, escrever (Recomendado)` e `Revisar uma decisão`. Se a resposta for revisar, volte ao Passo 3 só para o ponto indicado.

## Passo 5 — Escrever a spec

Crie `.ai/specs/<slug>.md` seguindo exatamente as seções e a numeração de `_template.md`:

- Cabeçalho: título, `Status: Pronta para planejamento`, área afetada e a data de hoje.
- Remova todos os comentários HTML do template.
- Seções marcadas como condicionais no template (UI/UX, acessibilidade) que não se aplicam ficam com `Não se aplica: <motivo>`.
- **IDs** conforme `.ai/WORKFLOW.md`: `RF-xx` na seção 7, `RNF-xx` nas seções 5 e 9, `CA-xx` na seção 11. Cada `CA` cita os `RF` que cobre e cada `RF` aparece em pelo menos um `CA`.
- Tabelas para campos, regras, copy, estados, critérios (`ID | Cobre | Dado | Quando | Então`) e QA (`Passo | Ação | Resultado esperado`).
- Textos, mensagens e valores copiados literalmente, como decididos.
- **Seção 14:** `Nenhuma decisão em aberto.` e, abaixo, a tabela `# | Pergunta | Decisão | Origem` com todas as decisões (origem: `usuário` ou `padrão do projeto`).
- **Seção 0:** tabela `Skill | Quando usar` com as skills escolhidas.

## Passo 6 — Auto-revisão

Releia o arquivo e corrija até tudo passar:

- [ ] Todas as seções presentes; nenhum `TODO`, `TBD`, `...` ou comentário HTML.
- [ ] Nenhum termo subjetivo sem definição: *adequado, amigável, intuitivo, bonito, moderno, rápido, simples, fácil, claro, bom, melhor, etc., quando necessário, se possível, aproximadamente, idealmente*. Cada um vira um valor, texto ou regra verificável, ou sai.
- [ ] Todo texto visível ao usuário está escrito literalmente.
- [ ] Todo `CA` é verificável por alguém que não participou da conversa.
- [ ] Todo item de "incluso" tem pelo menos um `CA` e um passo de QA.
- [ ] Todo `RF` aparece em pelo menos um `CA`.
- [ ] Nada contradiz restrições, código existente, ADRs ou outras specs.
- [ ] Caminhos, versões e comandos conferidos no repositório.

Se a auto-revisão revelar lacunas que dependem do usuário, junte todas num bloco, pergunte como no Passo 3 e reescreva os trechos.

## Passo 7 — Entrega

Responda em poucas linhas: caminho do arquivo, quantas perguntas foram feitas, as 3 a 5 decisões mais importantes e o próximo passo (`/create-plan <slug>`). Não cole a spec no chat.
