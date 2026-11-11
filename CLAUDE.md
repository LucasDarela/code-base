@AGENTS.md

## Específico do Claude Code

- Skills do fluxo ficam em `.claude/skills/`; agents (`implementer`, `assessor`) em `.claude/agents/`.
- Permissões e hooks estão em `.claude/settings.json`. Os hooks formatam cada arquivo editado (`make format FILE=...`) e rodam `make lint` ao final de cada resposta que alterou código. Se o hook de lint reclamar, corrija antes de encerrar.
- Use `AskUserQuestion` para decisões que são do usuário, agrupando até 4 perguntas independentes por chamada.
