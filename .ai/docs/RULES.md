# Regras de código

<!--
Preenchido pelo /bootstrap-project. Só regras que o linter e o formatador NÃO garantem: o que é automático
fica na configuração das ferramentas, não aqui. Cada regra com o motivo, para que o agente saiba aplicá-la
em casos que a regra não previu. Regras sem motivo viram cargo cult.
-->

## Princípios

- Siga o padrão do código ao redor antes de qualquer preferência pessoal. Consistência vale mais que a "melhor" solução isolada.
- Mudança mínima que resolve o problema. Refatorações oportunistas vão para uma spec própria.
- Código é lido muito mais vezes do que escrito: nomes explícitos, funções curtas, sem esperteza.
- Erros nunca são engolidos em silêncio. Ou são tratados com um comportamento definido na spec, ou propagados.

## Nomes

<!-- Convenções de nomes de arquivos, funções, variáveis, tabelas, rotas. Idioma do código (inglês?) e da UI (português?). -->

| Elemento | Convenção | Exemplo |
| -------- | --------- | ------- |
| Arquivos |           |         |
| Funções  |           |         |
| Tabelas  |           |         |

## Estrutura

<!-- Onde cada tipo de código mora. Remeta a ARCHITECTURE.md quando já estiver lá. -->

## Proibido

<!-- Com motivo. Ex.: "Não usar `any` em TypeScript: esconde erros que o compilador pegaria." -->

| Proibido | Motivo | Em vez disso |
| -------- | ------ | ------------ |
|          |        |              |

## Comentários e documentação

- Comente o **porquê**, nunca o **o quê**. Se precisa explicar o que o código faz, renomeie ou simplifique.
- Funções públicas de módulos compartilhados têm docstring com contrato (entradas, saídas, erros).

## Dependências

- Dependência nova só quando prevista na spec ou no plano, com versão fixada.
- Antes de adicionar, verifique se algo já instalado resolve.
