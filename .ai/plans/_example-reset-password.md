# Plano: Redefinição de senha

> **Spec:** `.ai/specs/_example-reset-password.md`
> **Criado em:** 2026-11-11
> **ADRs relacionados:** nenhum

> ℹ️ **Exemplo ilustrativo**, com stack fictícia, para mostrar o nível de detalhe esperado de um plano. Alvos como `make db-migrate` seriam acrescentados ao `Makefile` pelo próprio projeto.

## 1. Abordagem

Uma tabela nova guarda o hash SHA-256 de cada token, com validade e marca de uso. Toda a lógica de token fica isolada em `lib/auth/reset-token.ts` (funções puras + acesso ao banco), o que permite testar CA-06, CA-07, CA-12 e CA-13 sem subir páginas. As duas Server Actions só orquestram: validam com Zod, chamam o módulo de token e respondem. O rate limit usa a própria tabela de tokens (contagem por usuário nos últimos 15 minutos), o que evita adicionar Redis só para isso (RNF-05). Para e-mails não cadastrados não há linha a contar, mas também não há envio, então RNF-01 e RNF-03 continuam valendo.

## 2. Contratos

```ts
// db/schema/password-reset-tokens.ts
export const passwordResetTokens = pgTable("password_reset_tokens", {
  id: uuid("id").primaryKey().defaultRandom(),
  userId: uuid("user_id").notNull().references(() => users.id, { onDelete: "cascade" }),
  tokenHash: char("token_hash", { length: 64 }).notNull().unique(),
  expiresAt: timestamp("expires_at", { withTimezone: true }).notNull(),
  usedAt: timestamp("used_at", { withTimezone: true }),
  createdAt: timestamp("created_at", { withTimezone: true }).notNull().defaultNow(),
});

// lib/auth/reset-token.ts
export const RESET_TOKEN_TTL_MINUTES = 30;
export const RESET_RATE_LIMIT = { max: 3, windowMinutes: 15 };

export function hashToken(token: string): string;                       // SHA-256 hex
export async function createResetToken(userId: string): Promise<string | null>;
//   → null quando o rate limit estoura; invalida tokens anteriores não usados
export async function findValidToken(token: string): Promise<{ id: string; userId: string } | null>;
export async function consumeToken(tokenId: string): Promise<void>;     // marca usedAt

// lib/auth/actions.ts
type ActionResult = { ok: true } | { ok: false; fieldErrors: Record<string, string> };
export async function requestReset(formData: FormData): Promise<ActionResult>;
export async function resetPassword(formData: FormData): Promise<ActionResult>; // redireciona em sucesso
```

## 3. Dependências novas

Nenhuma.

## 4. Tarefas

- [ ] **T-01 — Tabela e migração**
  - Arquivos: `criar db/schema/password-reset-tokens.ts` · `criar db/migrations/NNNN_password_reset.sql` · `alterar db/schema/index.ts`
  - O que fazer: tabela da seção 2, índice em `(user_id, created_at)`. Migração com `up` e `down`.
  - Referência: `db/schema/sessions.ts:1-20`
  - Cobre: base para CA-13
  - Verificar: `make db-migrate && make db-rollback && make db-migrate`

- [ ] **T-02 — Módulo de token**
  - Arquivos: `criar lib/auth/reset-token.ts` · `criar lib/auth/reset-token.test.ts`
  - O que fazer: funções da seção 2. Token com `crypto.randomBytes(32).toString("base64url")`. `createResetToken` roda numa transação: conta tokens nos últimos 15 min, invalida os não usados (`used_at = now()`) e insere o novo.
  - Referência: `lib/auth/session.ts:30-58` (padrão de transação)
  - Cobre: CA-05, CA-06, CA-07, CA-12, CA-13
  - Verificar: `make test`

- [ ] **T-03 — Server Action de solicitação**
  - Arquivos: `alterar lib/auth/actions.ts` · `criar lib/auth/actions.reset.test.ts`
  - O que fazer: `requestReset` valida com Zod (RF-01, RF-02), busca o usuário, chama `createResetToken`, envia o e-mail de RF-05 via `lib/email/client.ts`. Sempre responde `{ ok: true }` para e-mail válido. Loga só `password_reset_requested` + `user_id`.
  - Referência: `lib/auth/actions.ts:12-40` (`signIn`)
  - Cobre: CA-01, CA-02, CA-03, CA-04, CA-14
  - Verificar: `make test`

- [ ] **T-04 — Server Action de nova senha**
  - Arquivos: `alterar lib/auth/actions.ts` · `alterar lib/auth/actions.reset.test.ts`
  - O que fazer: `resetPassword` valida (RF-07), chama `findValidToken`, grava o hash com `hashPassword()`, `consumeToken`, apaga as linhas de `sessions` do usuário e redireciona para `/login?redefinida=1`.
  - Referência: `lib/auth/session.ts:60-72` (`destroyAllSessions`)
  - Cobre: CA-08, CA-09, CA-10, CA-11
  - Verificar: `make test`

- [ ] **T-05 — Telas**
  - Arquivos: `criar app/(auth)/esqueci-senha/page.tsx` · `criar app/(auth)/redefinir-senha/page.tsx` · `alterar app/(auth)/login/page.tsx`
  - O que fazer: copy e estados das seções 7 e 8 da spec; acessibilidade da seção 9. Link e aviso no login (RF-09, RF-10).
  - Referência: `app/(auth)/login/page.tsx` (layout e padrão de formulário)
  - Cobre: CA-15, CA-16
  - Verificar: `make test` + passos 1 a 8 do roteiro de QA

- [ ] **T-06 — E2E do fluxo feliz**
  - Arquivos: `criar e2e/reset-password.spec.ts`
  - O que fazer: passos 1 a 7 do roteiro de QA, interceptando o envio de e-mail.
  - Referência: `e2e/login.spec.ts`
  - Cobre: CA-03, CA-10, CA-12, CA-15
  - Verificar: `make test`

## 5. Matriz de cobertura

| CA | Tarefa | Tipo de teste | Arquivo de teste |
| -- | ------ | ------------- | ---------------- |
| CA-01 | T-03 | unitário | `lib/auth/actions.reset.test.ts` |
| CA-02 | T-03 | unitário | `lib/auth/actions.reset.test.ts` |
| CA-03 | T-03, T-06 | integração + e2e | `actions.reset.test.ts`, `e2e/reset-password.spec.ts` |
| CA-04 | T-03 | integração | `lib/auth/actions.reset.test.ts` |
| CA-05 | T-02 | integração | `lib/auth/reset-token.test.ts` |
| CA-06 | T-02 | integração | `lib/auth/reset-token.test.ts` |
| CA-07 | T-02 | integração | `lib/auth/reset-token.test.ts` |
| CA-08 | T-04 | unitário | `lib/auth/actions.reset.test.ts` |
| CA-09 | T-04 | unitário | `lib/auth/actions.reset.test.ts` |
| CA-10 | T-04, T-06 | integração + e2e | `actions.reset.test.ts`, `e2e/reset-password.spec.ts` |
| CA-11 | T-04 | integração | `lib/auth/actions.reset.test.ts` |
| CA-12 | T-02, T-06 | integração + e2e | `reset-token.test.ts`, `e2e/reset-password.spec.ts` |
| CA-13 | T-02 | integração | `lib/auth/reset-token.test.ts` |
| CA-14 | T-03 | integração (spy no logger) | `lib/auth/actions.reset.test.ts` |
| CA-15 | T-06 | e2e | `e2e/reset-password.spec.ts` |
| CA-16 | T-05 | manual (leitor de tela) + axe no e2e | roteiro de QA |

## 6. Riscos e mitigação

| Risco | Mitigação |
| ----- | --------- |
| Diferença de tempo de resposta revela se o e-mail existe | Envio do e-mail fora do caminho da resposta (`after()` do Next.js) |
| Duas solicitações simultâneas passam do rate limit | Contagem e inserção na mesma transação (T-02) |

## 7. Registro de implementação

<!-- Preenchido pelo implementer ao final. -->

### Arquivos criados e alterados

### Desvios do plano

### Decisões durante a implementação

### CA sem teste automatizado
