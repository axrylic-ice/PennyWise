# PennyWise AI

A personal purchase-decision assistant based on Team Apex's PennyWise AI OPEN//BUILD 2026 brief. Each signed-in user starts with an empty, separate workspace. There are no seeded financial balances, fake transactions, example purchases or client-supplied inference keys.

## Product

- Overview: setup guidance, personal calendar and recent decisions.
- My money: available cash, a reserve, a chosen outlook, dated commitments, recurring costs and income certainty.
- Make a decision: natural-language extraction, voice recording/upload, transcription review, targeted clarification, editable confirmation and manual entry.
- Forecasts: buy now, delay, skip and custom-date comparisons, minimum balances, first shortfall, daily ledger, grounded explanations and alternatives.
- Imports: private bank-statement and receipt uploads, text PDF/CSV/TXT extraction, image/scanned-PDF OCR, editable transaction review, private downloads and deletion.
- Settings: account identity, data export, explicit permanent deletion and privacy details.

Historical imports never automatically become future commitments or change the starting balance. The user must explicitly select reviewed future-dated entries or choose to use a reviewed closing balance. Non-NGN imports cannot be added to the naira forecast. Statements do not link a bank account or initiate payments.

## Architecture and isolation

React/Vinext/Vite on Sites/Cloudflare Workers. `DB` is D1 for user-owned workspaces, scenarios and import metadata. `BUCKET` is R2 for original documents. Every API endpoint requires the platform-provided `oai-authenticated-user-id`. Every record operation, list, export and file download is scoped to this identity, including when an ID is already known. Caller-supplied user IDs are never accepted. JSON and multipart bodies are bounded. Workspace writes use optimistic version checking. Browser financial storage from the old prototype is removed rather than silently attributed to a signed-in account. No financial records or keys are saved in localStorage.

The site retains its existing private audience. Native Sites authentication is used; no custom password database is added. Full browser QA of a signed-in flow requires a user-authorized browser session. API isolation tests use separate synthetic users against real in-memory SQLite implementing the D1 query contract.

## Internal AI services

`GROQ_API_KEY` is a server-only Sites secret. No BYOK form or model configuration is exposed to visitors. No API key, model identifier or provider configuration is included in the client output. The end-user privacy explanation names Groq as the processing provider. No API key is committed to source, logs or evaluation reports.

The financial assistant uses open-weight `openai/gpt-oss-120b` through Groq with a strict output schema. Whisper `whisper-large-v3-turbo` transcribes audio through the backend. Tesseract.js performs English OCR locally in the browser; PDF.js extracts PDF text and renders scans. Language assets may be downloaded by the OCR worker, but the OCR itself does not upload the document image to an OCR service. After explicit consent, extracted text is sent to Groq for structured interpretation.

Read `docs/AI.md` for responsibilities, model information, licenses, evaluation results and known limitations.

## Run and deploy

Use Node 22.13+ and pnpm. Run `pnpm install` and `pnpm dev`. For standalone local server testing, put `GROQ_API_KEY` in an ignored `.dev.vars` file. Hosted configuration uses native Sites secrets. Preserve `.openai/hosting.json` and its project identity. Sites provisions D1/R2 and applies the generated `drizzle` migrations during deployment.

After building, apply the initial SQL to local D1 with `node --import ./scripts/sites-env.mjs ./node_modules/wrangler/bin/wrangler.js d1 execute DB --local --config dist/server/wrangler.json --persist-to .wrangler/state --file drizzle/0000_chunky_galactus.sql`. Do not rerun an already applied migration. Local storage is separate from hosted storage. Use the Sites build/source/deployment helpers for publication. The private deployed origin is recorded by Sites.

## Verification

`node --test tests/*.test.mjs`: calculator, extraction guards, request contracts, authentication, user isolation, optimistic locking, file access and deletion. `node node_modules/typescript/bin/tsc --noEmit`: TypeScript. Production build uses Sites `build-site.mjs`.

The original 20-case live extraction run passed 12 cases, found four model mistakes and encountered four rate limits. That is not a production accuracy claim. Those observations led to weekday calendar context, missing-field questions and invalid-date guards. Follow-up live tests passed weekday extraction, missing-reserve handling, statement parsing and receipt parsing. One Pidgin case initially failed; a glossary correction was then tested successfully. A synthetic spoken clip was transcribed successfully and a synthetic receipt was recognized using Tesseract. These are smoke tests, not broad language, OCR or speech accuracy evaluations. Reports are in `docs/evaluation-*.json` and contain invented financial examples only.

## Limits and submission work

Ninety-day outlook; up to 100 commitments, 100 saved decisions and 50 files per user; 8 MB per document; 10 pages per text PDF, five per scanned PDF; 200 transactions per document; 10 MB per audio upload and 90 seconds per recording. Poor scans, handwriting, protected PDFs, complex layouts, accents and slang can produce errors or require manual entry. Groq rate limits and outages surface as retryable errors. The per-user inference burst guard is isolate-local, not a distributed billing quota.

The brief deliberately excludes bank linking, payments, autonomous buying, live merchant aggregation, long-term predictions and investment advice. These remain excluded. Before hackathon submission, arrange judge access, provide the team's full names/universities, choose a source-code license and publish a judge-accessible repository. No public GitHub repository or immutable hosted weight revision is claimed.

## Acknowledgements

Concept: supplied Team Apex brief. Implementation substantially AI-assisted using Codex. Model weights: OpenAI gpt-oss (Apache 2.0), Whisper (MIT). Inference: Groq. OCR: Tesseract.js (Apache 2.0). PDF processing: PDF.js (Apache 2.0). Hosting and framework dependencies retain their licenses. Fonts: DM Sans and Manrope from Google Fonts. No real bank records were used for testing. No source distribution license is selected on the team's behalf.
