# [Nome da feature]

> **Status:** Pronta para planejamento
> **Área:** `/rota`, módulo ou serviço afetado
> **Última atualização:** AAAA-MM-DD

<!--
Como usar este template (veja um exemplo completo em _example-reset-password.md):
- Status válidos e IDs (RF, RNF, CA) estão definidos em .ai/WORKFLOW.md.
- Seja específico. Prefira "mensagem 'Informe um e-mail válido.'" a "mensagem de erro adequada".
- Tudo que não estiver escrito aqui está FORA do escopo.
- Seções marcadas como (condicional) recebem "Não se aplica: <motivo>" quando não fizerem sentido.
- Remova todos os comentários HTML ao finalizar.
-->

## 0. Skills obrigatórias

<!-- Skills que quem implementa carrega antes de escrever código. Só skills disponíveis na sessão ou aprovadas pelo usuário. -->

| Skill | Quando usar |
| ----- | ----------- |
|       |             |

## 1. Contexto

<!-- Por que essa feature existe? Qual problema resolve e para quem? Cite regras de BUSINESS.md (RN-xx) quando houver. -->

## 2. Objetivo

<!-- Uma ou duas frases com o resultado verificável ao final desta entrega. -->

## 3. Estado atual

<!-- O que já existe no código (arquivos, componentes, endpoints, tabelas) e o destino de cada parte: manter, alterar ou remover. -->

## 4. Tecnologias e versões

<!-- Só o que é relevante para esta entrega. -->

| Tecnologia | Versão | Situação (instalada / adicionar) | Uso nesta entrega |
| ---------- | ------ | -------------------------------- | ----------------- |
|            |        |                                  |                   |

## 5. Restrições e requisitos não funcionais

<!-- Regras que a implementação não pode quebrar (técnicas, de produto, de arquitetura) e requisitos de desempenho, segurança, observabilidade e privacidade, com ID. -->

| ID | Requisito |
| -- | --------- |
| RNF-01 |       |

## 6. Escopo

### 6.1 Incluso

### 6.2 Não incluso

## 7. Especificação funcional

<!-- Campos, regras de validação, mensagens exatas, estados e comportamento de cada interação. Use tabelas. Cada regra recebe um ID RF-xx. -->

| ID | Requisito |
| -- | --------- |
| RF-01 |        |

### 7.1 Casos de borda

<!-- Entrada inválida, duplo envio, concorrência, sem permissão, sem dados, falha de serviço externo. -->

## 8. Especificação de UI/UX (condicional)

<!-- Layout, hierarquia, copy exata, breakpoints com larguras, temas, estados visuais (hover, focus, disabled, erro, loading). -->

## 9. Acessibilidade (condicional)

<!-- Requisitos concretos e verificáveis, WCAG 2.2 AA como base. IDs RNF-xx. -->

## 10. Estrutura de arquivos esperada

<!-- Árvore com os arquivos a criar ou alterar e a responsabilidade de cada um. O plano detalha; aqui é a visão geral. -->

## 11. Critérios de aceitação

<!-- Formato Dado/Quando/Então, verificável por alguém que não participou da conversa. Cada CA cita os RF que cobre. -->

| ID | Cobre | Dado | Quando | Então |
| -- | ----- | ---- | ------ | ----- |
| CA-01 | RF-01 |    |        |       |

## 12. Roteiro de QA

<!-- Passos manuais numerados, cada um com o resultado esperado. -->

| Passo | Ação | Resultado esperado |
| ----- | ---- | ------------------ |
| 1     |      |                    |

## 13. Definition of Done

- [ ] `make check` passa (lint, tipos, testes, build)
- [ ] Todo `CA` tem teste automatizado com o ID no nome, ou justificativa de teste manual no plano
- [ ] Roteiro de QA executado sem divergências
- [ ] Registro de implementação preenchido no plano
- [ ] Nenhum segredo, dado pessoal ou log sensível introduzido (ver `.ai/docs/SECURITY.md`)
<!-- Acrescente itens específicos desta entrega (responsividade, temas, migração aplicada...). -->

## 14. Decisões em aberto

<!-- Ao finalizar: "Nenhuma decisão em aberto." + tabela com o histórico de decisões. -->

| # | Pergunta | Decisão | Origem (usuário / padrão do projeto) |
| - | -------- | ------- | ------------------------------------ |

## 15. Próximos passos (fora desta entrega)

<!-- O que vem depois, para dar contexto sem entrar no escopo. -->
