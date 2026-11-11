# Interface estável de comandos do projeto.
#
# Agentes, hooks e CI chamam SOMENTE estes alvos. Quando a stack mudar,
# muda o corpo dos alvos, nunca os nomes. O /bootstrap-project preenche
# cada alvo com os comandos reais da stack escolhida.
#
# Enquanto um alvo não estiver configurado, ele avisa e sai com sucesso,
# para não quebrar hooks e CI de um projeto recém-criado.

.PHONY: help setup dev format lint test build check

FILE ?= .

help: ## Lista os comandos
	@grep -E '^[a-zA-Z_-]+:.*?## ' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-10s\033[0m %s\n", $$1, $$2}'

setup: ## Instala dependências
	@echo "[make setup] não configurado — rode /bootstrap-project"

dev: ## Sobe o ambiente local
	@echo "[make dev] não configurado — rode /bootstrap-project"

format: ## Formata o código (FILE=caminho para um arquivo só)
	@echo "[make format] não configurado — rode /bootstrap-project"

lint: ## Lint + checagem de tipos
	@echo "[make lint] não configurado — rode /bootstrap-project"

test: ## Testes automatizados
	@echo "[make test] não configurado — rode /bootstrap-project"

build: ## Build de produção
	@echo "[make build] não configurado — rode /bootstrap-project"

check: lint test build ## Tudo que a CI exige (lint + test + build)
