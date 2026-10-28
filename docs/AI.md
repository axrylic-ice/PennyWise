# Internal AI integration and evaluation

## Models

- Financial extraction/explanation checkpoint: `openai/gpt-oss-120b`, Apache 2.0, hosted by Groq. Model card: https://huggingface.co/openai/gpt-oss-120b . Provider alias is not an immutable pinned weight revision. No offline inference claim.
- Speech: `whisper-large-v3-turbo`, MIT, hosted by Groq. Model card: https://huggingface.co/openai/whisper-large-v3-turbo . Audio is not persisted by PennyWise; provider processing/retention follows its terms.
- OCR: Tesseract.js 7 with English traineddata, Apache 2.0. Browser processing, followed by user-consented structured extraction. PDF.js extracts text/rendered pages.

## Responsibilities

The model extracts amounts, dates, names, recurrence, certainty and source evidence; asks clarifications; interprets statement and receipt text; and explains computed scenario tradeoffs. `lib/ai-schema.mjs` and `lib/import-schema.mjs` contain strict schemas and prompts. The server validates output and withholds malformed or incomplete responses. Known user-confirmed workspace data is context. Source quotes and all fields are reviewed by the user.

Calendar context gives concrete weekday dates; guards null conflicting weekday dates and request confirmation instead of silently applying them. Missing material values always produce questions even when the model omits them. Limited Pidgin expressions are explained in the prompt. This does not imply validated support for all dialects.

The calculator uses integer-kobo arithmetic. It adds confirmed daily income and subtracts expenses and the scenario purchase, including the initial balance when finding the minimum. Estimated and uncertain income is excluded; non-confirmed expenses are included and flagged. It compares buy-now, delay, skip and a chosen date without another model call. Explanations receive server-recomputed summaries. Numeric digits are prohibited in explanation prose and detected digits cause rejection; exact figures stay in the chart. This guard does not prove all prose semantically correct.

## Measured evidence on October 28, 2026

- Initial twenty-case real-provider run: twelve passed expectations; four returned model mistakes (weekday dates or missing clarification); four encountered rate limits. Raw results are retained in `evaluation-initial.json`.
- Follow-up real-provider probes: weekday date, reserve guard, bank statement and receipt passed. Pidgin initially misclassified current cash as income.
- After adding Pidgin guidance, that synthetic case passed. Synthetic speech transcription passed. See `evaluation-followup.json` and `evaluation-voice-pidgin.json`.
- A printed synthetic receipt OCR test passed the store/total checks at engine-reported confidence 94. This is a single-engine confidence, not a measured general OCR accuracy percentage.
- Automated tests cover calculations, extraction guards, mocked provider contracts, authentication and isolation between two synthetic user identities. They do not count as live inference accuracy results.

## Known failure modes

Provider rate limiting and outages; broad model hallucinations not fully eliminated by schema; unclear slang or debt wording; date interpretations; receipt totals versus line items; table layout reconstruction; accents and noisy recordings; poor scans/handwriting; textless/protected PDFs; non-NGN documents; records omitted by the user. Review remains necessary. Imported historical records are never automatically treated as future cash flow. No bank credentials, purchases, investment advice or guaranteed affordability are offered.

## Privacy boundary

Secret held only in Sites runtime. The client cannot supply an inference key or choose arbitrary provider URLs/models. All API operations require signed-in identity and authorize records by owner on the server. File/object keys are never exposed. Raw documents use private R2; metadata and reviewed scenarios use owner-scoped D1. Data exports exclude keys. Account deletion removes records and original uploads owned by the requester. Provider retention is outside this application's deletion boundary.
