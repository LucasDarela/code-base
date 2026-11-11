# Redefinição de senha

> **Status:** Pronta para planejamento
> **Área:** `/esqueci-senha`, `/redefinir-senha`, módulo `auth`
> **Última atualização:** 2026-11-11

> ℹ️ **Exemplo ilustrativo.** Esta spec usa uma stack fictícia (TypeScript, Next.js 15, PostgreSQL, Resend) para mostrar o **nível de detalhe** esperado. Não é uma feature deste repositório.

## 0. Skills obrigatórias

| Skill | Quando usar |
| ----- | ----------- |
| `vercel-react-best-practices` | Componentes de página e Server Actions |
| `web-design-guidelines` | Revisão final dos formulários (estados, foco, mensagens) |

## 1. Contexto

Hoje, quem esquece a senha precisa escrever para o suporte, que redefine manualmente. São cerca de 40 chamados por semana (dado do suporte, outubro/2026), com tempo médio de resposta de 6 horas. Esta é a primeira feature de autoatendimento da conta e segue a regra RN-04 de `BUSINESS.md` (o suporte nunca vê nem define senhas).

## 2. Objetivo

A pessoa usuária redefine a própria senha por e-mail, sem contato com o suporte, em até 3 telas.

## 3. Estado atual

| Item | Situação | Destino |
| ---- | -------- | ------- |
| `app/(auth)/login/page.tsx` | Tela de login, sem link de recuperação | Alterar: adicionar link "Esqueci minha senha" |
| `lib/auth/password.ts` | `hashPassword()` e `verifyPassword()` com argon2 | Manter e reutilizar |
| `lib/email/client.ts` | Cliente Resend já configurado | Manter e reutilizar |
| Tabela `users` | Possui `email` (único) e `password_hash` | Manter |
| Tabela de tokens de redefinição | Não existe | Criar |

## 4. Tecnologias e versões

| Tecnologia | Versão | Situação | Uso nesta entrega |
| ---------- | ------ | -------- | ----------------- |
| Next.js | 15.1 | instalada | Páginas e Server Actions |
| Drizzle ORM | 0.36 | instalada | Tabela e consultas de token |
| Resend | 4.0 | instalada | Envio do e-mail |
| Zod | 3.23 | instalada | Validação dos formulários |

## 5. Restrições e requisitos não funcionais

| ID | Requisito |
| -- | --------- |
| RNF-01 | A resposta da solicitação é idêntica exista ou não o e-mail cadastrado (não revela quais e-mails têm conta). |
| RNF-02 | O token tem 32 bytes aleatórios (CSPRNG). Só o hash SHA-256 do token é gravado no banco. |
| RNF-03 | Limite de 3 solicitações por e-mail a cada 15 minutos. A partir da 4ª, nenhum e-mail é enviado, mas a resposta continua idêntica (RNF-01). |
| RNF-04 | Nenhum log contém o token, o link ou a senha. Logar apenas `user_id` e o evento (`password_reset_requested`, `password_reset_completed`). |
| RNF-05 | Nenhuma dependência nova. |

## 6. Escopo

### 6.1 Incluso

- Link "Esqueci minha senha" na tela de login.
- Tela de solicitação (`/esqueci-senha`) e envio do e-mail.
- Tela de nova senha (`/redefinir-senha?token=...`).
- Invalidação do token após uso ou expiração.
- Encerramento de todas as sessões ativas após a redefinição.

### 6.2 Não incluso

- Redefinição por SMS ou por pergunta secreta.
- Troca de senha estando logado (tela de perfil).
- Template visual de e-mail com marca (será texto simples nesta entrega).
- Painel do suporte para ver solicitações.

## 7. Especificação funcional

### 7.1 Solicitação

| ID | Requisito |
| -- | --------- |
| RF-01 | Campo `email`: obrigatório, `trim` + minúsculas antes de validar, formato de e-mail (Zod `.email()`), máximo 254 caracteres. |
| RF-02 | E-mail vazio → mensagem `Informe seu e-mail.` E-mail com formato inválido → `Informe um e-mail válido.` Validação ao enviar, não ao digitar. |
| RF-03 | Ao enviar um e-mail válido, a tela mostra `Se este e-mail estiver cadastrado, você receberá um link em instantes. Confira também a caixa de spam.` e oculta o formulário. |
| RF-04 | Se o e-mail existir, cria um token válido por **30 minutos** e envia o e-mail. Tokens anteriores não usados desse usuário são invalidados. |
| RF-05 | E-mail: assunto `Redefinição de senha`, corpo `Recebemos um pedido para redefinir sua senha. Para criar uma nova, acesse: {link}. O link vale por 30 minutos. Se não foi você, ignore este e-mail.` |

### 7.2 Nova senha

| ID | Requisito |
| -- | --------- |
| RF-06 | Ao abrir `/redefinir-senha?token=X`, o token é validado. Token inexistente, expirado ou já usado → tela com `Este link expirou ou já foi usado.` e o botão `Pedir novo link`, que leva a `/esqueci-senha`. |
| RF-07 | Campos `senha` e `confirmação`: senha com 8 a 72 caracteres, ao menos uma letra e um número. Mensagens: `A senha precisa ter entre 8 e 72 caracteres.`, `A senha precisa ter ao menos uma letra e um número.`, `As senhas não coincidem.` |
| RF-08 | Ao salvar: grava o hash com `hashPassword()`, marca o token como usado, encerra todas as sessões do usuário e redireciona para `/login?redefinida=1`. |
| RF-09 | Em `/login?redefinida=1`, a tela de login mostra o aviso `Senha redefinida. Entre com a nova senha.` |
| RF-10 | Link `Esqueci minha senha` abaixo do campo de senha na tela de login, levando a `/esqueci-senha`. |

### 7.3 Casos de borda

| Situação | Comportamento |
| -------- | ------------- |
| Duplo clique em "Enviar link" | Botão desabilitado com o texto `Enviando...` enquanto a ação roda; só uma solicitação é processada. |
| Duas abas com links diferentes | Só o token mais recente é válido (RF-04). |
| Falha no envio do e-mail (Resend fora) | Mesma mensagem de RF-03 para o usuário; erro logado com `user_id` e código do erro (RNF-04). |
| Token válido, mas usuário excluído | Tratado como token inexistente (RF-06). |

## 8. Especificação de UI/UX

- As duas telas usam o mesmo layout de `app/(auth)/login/page.tsx`: card centralizado de 400px de largura máxima e 16px de margem lateral em telas menores que 440px.
- Títulos: `Esqueci minha senha` e `Criar nova senha`.
- Botões: `Enviar link` e `Salvar nova senha`. Durante o envio: `Enviando...` e `Salvando...`, desabilitados.
- Erros de campo aparecem abaixo do campo, na cor `--destructive` do tema.
- Funciona nos temas claro e escuro já existentes.

## 9. Acessibilidade

| ID | Requisito |
| -- | --------- |
| RNF-06 | Cada campo tem `<label>` visível associado. |
| RNF-07 | Mensagens de erro ligadas ao campo via `aria-describedby`; o campo recebe `aria-invalid="true"`. |
| RNF-08 | A mensagem de sucesso de RF-03 fica num elemento com `role="status"`. |
| RNF-09 | Ao enviar com erro, o foco vai para o primeiro campo inválido. |

## 10. Estrutura de arquivos esperada

```
app/(auth)/esqueci-senha/page.tsx        # tela de solicitação
app/(auth)/redefinir-senha/page.tsx      # tela de nova senha
app/(auth)/login/page.tsx                # alterar: link + aviso RF-09
lib/auth/reset-token.ts                  # gerar, validar e consumir token
lib/auth/actions.ts                      # Server Actions requestReset e resetPassword
db/schema/password-reset-tokens.ts       # tabela nova
db/migrations/NNNN_password_reset.sql    # migração
```

## 11. Critérios de aceitação

| ID | Cobre | Dado | Quando | Então |
| -- | ----- | ---- | ------ | ----- |
| CA-01 | RF-01, RF-02 | a tela `/esqueci-senha` | envio com o campo vazio | vejo `Informe seu e-mail.` e nenhuma solicitação é criada |
| CA-02 | RF-02 | a tela `/esqueci-senha` | envio `abc@` | vejo `Informe um e-mail válido.` |
| CA-03 | RF-03, RF-04, RF-05, RNF-01 | um e-mail cadastrado | envio o formulário | vejo a mensagem de RF-03 e um e-mail com o assunto e o corpo de RF-05 é enviado |
| CA-04 | RF-03, RNF-01 | um e-mail **não** cadastrado | envio o formulário | vejo exatamente a mesma mensagem de CA-03 e nenhum e-mail é enviado |
| CA-05 | RNF-03 | 3 solicitações para o mesmo e-mail nos últimos 15 min | faço a 4ª | vejo a mesma mensagem e nenhum e-mail é enviado |
| CA-06 | RF-06 | um token com mais de 30 minutos | abro o link | vejo `Este link expirou ou já foi usado.` e o botão `Pedir novo link` |
| CA-07 | RF-04, RF-06 | dois tokens gerados para o mesmo usuário | abro o link do primeiro | vejo a tela de link expirado |
| CA-08 | RF-07 | a tela de nova senha | digito `abcdefgh` | vejo `A senha precisa ter ao menos uma letra e um número.` |
| CA-09 | RF-07 | a tela de nova senha | digito senhas diferentes nos dois campos | vejo `As senhas não coincidem.` |
| CA-10 | RF-08, RF-09 | um token válido | salvo uma senha válida | sou levado a `/login?redefinida=1`, vejo o aviso de RF-09 e consigo entrar com a nova senha |
| CA-11 | RF-08 | um usuário com sessão aberta em outro navegador | redefine a senha | a outra sessão é encerrada na próxima requisição |
| CA-12 | RF-08 | um token já usado em CA-10 | abro o link de novo | vejo a tela de link expirado |
| CA-13 | RNF-02 | uma solicitação feita | consulto a tabela de tokens | só existe o hash SHA-256, nunca o token puro |
| CA-14 | RNF-04 | o fluxo completo executado | busco nos logs pelo token e pela senha | nenhuma ocorrência |
| CA-15 | RF-10 | a tela de login | clico em `Esqueci minha senha` | sou levado a `/esqueci-senha` |
| CA-16 | RNF-06 a RNF-09 | as duas telas | navego só com teclado e leitor de tela | labels, erros e mensagem de sucesso são anunciados e o foco vai ao primeiro campo inválido |

## 12. Roteiro de QA

| Passo | Ação | Resultado esperado |
| ----- | ---- | ------------------ |
| 1 | Na tela de login, clique em `Esqueci minha senha` | Abre `/esqueci-senha` |
| 2 | Clique em `Enviar link` com o campo vazio | `Informe seu e-mail.` abaixo do campo; foco no campo |
| 3 | Envie um e-mail cadastrado | Mensagem de RF-03; e-mail chega em até 1 minuto |
| 4 | Abra o link do e-mail | Tela `Criar nova senha` |
| 5 | Salve `senha123` nos dois campos | Redireciona ao login com `Senha redefinida. Entre com a nova senha.` |
| 6 | Entre com `senha123` | Login funciona |
| 7 | Abra de novo o link do passo 4 | `Este link expirou ou já foi usado.` |
| 8 | Repita os passos 1 a 7 no tema escuro e em 375px de largura | Mesmo comportamento, sem rolagem horizontal |

## 13. Definition of Done

- [ ] `make check` passa (lint, tipos, testes, build)
- [ ] Todo `CA` tem teste automatizado com o ID no nome, ou justificativa de teste manual no plano
- [ ] Roteiro de QA executado sem divergências
- [ ] Registro de implementação preenchido no plano
- [ ] Nenhum segredo, dado pessoal ou log sensível introduzido (ver `.ai/docs/SECURITY.md`)
- [ ] Migração aplicada e reversível (`down` testado)

## 14. Decisões em aberto

Nenhuma decisão em aberto.

| # | Pergunta | Decisão | Origem |
| - | -------- | ------- | ------ |
| 1 | Validade do token | 30 minutos | usuário |
| 2 | Revelar se o e-mail existe? | Não, resposta idêntica | usuário |
| 3 | Encerrar outras sessões após redefinir? | Sim, todas | usuário |
| 4 | Regra de senha | 8 a 72 caracteres, letra e número | usuário |
| 5 | Rate limit | 3 por e-mail a cada 15 min | usuário |
| 6 | E-mail com marca? | Não, texto simples nesta entrega | usuário |
| 7 | Layout das telas | Reutilizar o card do login | padrão do projeto |
| 8 | Biblioteca de validação | Zod, já usada em `lib/validation` | padrão do projeto |

## 15. Próximos passos (fora desta entrega)

- Template de e-mail com a identidade visual.
- Troca de senha na tela de perfil.
- Alerta por e-mail quando a senha for alterada.
