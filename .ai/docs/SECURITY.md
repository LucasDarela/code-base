# Segurança e privacidade

<!--
Preenchido pelo /bootstrap-project. Usado pelo /create-spec (requisitos RNF de segurança), pelo /create-plan
e como régua pelo agent assessor. Código gerado por IA tende a omitir autorização e validação de entrada;
este arquivo existe para que isso seja verificado explicitamente.
-->

## Dados tratados

| Dado | Classificação | Onde fica | Base legal (LGPD) | Retenção |
| ---- | ------------- | --------- | ----------------- | -------- |
|      | público / interno / pessoal / sensível | | | |

## Autenticação e autorização

<!-- Como a pessoa se autentica, como as sessões funcionam, qual o modelo de permissão (papéis, donos do recurso). -->

## Segredos

- Segredos só em variáveis de ambiente ou no cofre de segredos do ambiente. Nunca no código, em logs, em testes ou em commits.
- `.env.example` documenta toda variável necessária, com valor fictício.
- Agentes de IA não leem `.env*` (bloqueado em `.claude/settings.json`).
- Segredo vazado é revogado e trocado na hora; remover do histórico não basta.

## Checklist para toda feature

Baseado no OWASP Top 10. O assessor verifica estes itens no diff.

- [ ] Toda rota ou ação nova verifica **autorização** (não só autenticação): a pessoa pode agir sobre **este** recurso?
- [ ] Toda entrada externa é validada no servidor com schema (tipo, formato, tamanho), mesmo que o cliente também valide.
- [ ] Consultas ao banco são parametrizadas; nada de SQL montado com concatenação.
- [ ] Saída para HTML é escapada; nenhum `innerHTML` ou equivalente com dado do usuário.
- [ ] Mensagens de erro não expõem stack trace, SQL ou a existência de registros (ex.: "e-mail não cadastrado").
- [ ] Ações sensíveis (login, redefinição de senha, pagamento) têm rate limit.
- [ ] Nenhum dado pessoal ou segredo em log (ver `O11Y.md`).
- [ ] Uploads validam tipo e tamanho e não são servidos do mesmo domínio sem cuidado.
- [ ] Dependências novas sem vulnerabilidades conhecidas.

## Reporte de vulnerabilidades

<!-- Para quem e como reportar. -->
