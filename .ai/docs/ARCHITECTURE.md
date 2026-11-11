# Arquitetura

<!--
Preenchido pelo /bootstrap-project e mantido a cada ADR. Responde "como o sistema está organizado".
Decisões e seus motivos ficam nos ADRs (.ai/adrs/); aqui fica o estado atual.
-->

## Stack

| Camada | Tecnologia | Versão | ADR |
| ------ | ---------- | ------ | --- |
| Linguagem |         |        |     |
| Framework |         |        |     |
| Banco de dados |    |        |     |
| ORM / acesso a dados | |      |     |
| Autenticação |      |        |     |
| Testes |            |        |     |
| Hospedagem / deploy | |       |     |

## Arquivos de configuração relevantes

<!-- Onde o agente deve olhar para confirmar versões e configurações. Ex.: package.json, tsconfig.json, pyproject.toml. -->

## Estrutura de pastas

<!-- Árvore de 2 a 3 níveis com a responsabilidade de cada pasta. -->

```
```

## Camadas e dependências

<!--
Quem pode importar quem. Ex.: "ui → application → domain; infra implementa interfaces de domain; domain não importa nada externo".
Regras de dependência violadas são o problema arquitetural mais comum em código gerado por IA.
-->

## Padrões de referência

<!--
Para cada tipo de artefato, um arquivo existente que serve de modelo. O /create-plan usa esta tabela para mandar
o implementer "seguir o padrão de X". Mantenha atualizado conforme o código cresce.
-->

| Para criar... | Siga o padrão de |
| ------------- | ---------------- |
| Endpoint / rota |               |
| Componente de UI |              |
| Acesso a dados |                |
| Teste unitário |                |
| Teste e2e |                     |

## Integrações externas

| Serviço | Para quê | Onde está o cliente | Variáveis de ambiente |
| ------- | -------- | ------------------- | --------------------- |
|         |          |                     |                       |

## Ambientes

| Ambiente | URL | Deploy | Observações |
| -------- | --- | ------ | ----------- |
| local    |     | `make dev` |         |
