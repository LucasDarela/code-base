# Qualidade e testes

<!--
Preenchido pelo /bootstrap-project. Define o que é "testado o suficiente" neste projeto, as ferramentas
e onde os testes moram. O agent implementer escreve testes seguindo este arquivo; o assessor o usa como régua.
-->

## Comandos

| O quê | Comando |
| ----- | ------- |
| Formatar | `make format` |
| Lint + tipos | `make lint` |
| Testes | `make test` |
| Tudo (o que a CI roda) | `make check` |

## Ferramentas

| Função | Ferramenta | Configuração |
| ------ | ---------- | ------------ |
| Formatador |        |              |
| Linter |            |              |
| Tipos |             |              |
| Testes unitários/integração | |    |
| Testes e2e |        |              |

## Estratégia

<!-- Quanto de cada tipo de teste e para quê. Ajuste ao projeto. -->

| Tipo | Quando usar | Onde fica |
| ---- | ----------- | --------- |
| Unitário | Regras de negócio e funções puras | |
| Integração | Acesso a dados, APIs, Server Actions | |
| E2E | Fluxos críticos do roteiro de QA | |
| Manual | Visual, acessibilidade com leitor de tela | Roteiro de QA da spec |

## Convenções

- Todo teste ligado a um critério de aceitação inclui o ID no nome: `CA-03: exibe erro para e-mail inválido`. É isso que permite ao `/assessment-spec` rastrear cobertura.
- Teste comportamento observável, não detalhes de implementação.
- Um teste falha por um motivo só. Nomes descrevem o cenário, não a função.
- Testes não dependem de ordem, de rede externa nem de horário real (use relógio controlado).
- Bug corrigido ganha um teste que falhava antes da correção.

## Cobertura

<!-- Meta e o que fica de fora. Ex.: "80% de linhas em domain/; UI coberta por e2e dos fluxos críticos". -->

## Dados de teste

<!-- Fixtures, factories, seed. Nunca dados reais de produção. -->
