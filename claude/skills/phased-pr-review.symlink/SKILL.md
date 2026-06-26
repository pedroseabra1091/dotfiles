---
name: phased-pr-review
description: Walk the current branch's PR diff one file at a time, delegating each file's review to the pr-review skill and pausing between files for input. Use when the user wants a phased / file-by-file PR review instead of one batched pass, or mentions "phased pr review", "review file by file", or "walk the PR".
---

Drive a phased PR review by walking the diff one file at a time and delegating each file to the `pr-review` skill via the Skill tool. Add only orchestration on top of `pr-review`; do not restate or duplicate its review logic.

## Operating rules

- Do not narrate internal workflow or phases to the user. Progress and methodology stay implicit.
- The walk must run on a capable model (Opus) with effort set to high, unless the user specifies otherwise, since the orchestrator performs the reviews itself and accumulates cross-file context. Ancillary operations (marking files as viewed, etc.) are delegated to a cheap model (Haiku).

## 1. Resolve scope from the PR

Run `gh pr view --json baseRefName,headRefName,number,url,id` with no args — this inspects the PR associated with the current branch. Treat `baseRefName` as the base; do not try to infer it from `git symbolic-ref` or by defaulting to `main`/`master`. Hold on to `id` (the PR's GraphQL node ID) — it's needed in step 3 to mark files as viewed.

If `gh` reports no PR for the current branch, ask the user whether to (a) supply a PR reference / number to read instead, or (b) abort. Do not silently fall back to a guessed base.

Once the base is known, list changed files with `git diff --name-only origin/<baseRefName>...HEAD`. If the list is empty, stop and tell the user there's nothing to review.

If the working tree is dirty, mention it once up front; continue to diff against the committed state unless the user asks otherwise.

## 2. Announce the plan

Print the ordered list of changed files with a counter, e.g. `7 files to review`. This is the only batch-level output before per-file work begins.

## 3. Per-file loop

For each file, in order:

1. Print a header: `Reviewing N/total: <path>`.
2. Review the file directly in the orchestrator — do **not** delegate to a subagent. Invoke the `pr-review` skill scoped to this file's diff (`git diff origin/<baseRefName>...HEAD -- <path>`) at maximum effort. Reviewing in the orchestrator's own context is deliberate: knowledge accumulates as the walk progresses, so later files are reviewed with awareness of signatures, abstractions, and patterns introduced in earlier ones. Carry that prior-file context forward when it bears on the current file.
3. Surface `pr-review`'s findings verbatim under that file's header. If pr-review returns nothing actionable, say so and move on — do not fabricate findings.
4. Pause and wait for the user. Accept at least:
   - `next` — spawn a **background** subagent to mark this file as Viewed on GitHub, then advance immediately without waiting on the result. Use the Agent tool with `subagent_type: general-purpose`, `model: haiku`, and `run_in_background: true`. The subagent runs:
     ```sh
     gh api graphql \
       -f query='mutation($prId: ID!, $path: String!) { markFileAsViewed(input: {pullRequestId: $prId, path: $path}) { pullRequest { id } } }' \
       -F prId="<pr id from step 1>" \
       -F path="<file path>"
     ```
     The orchestrator does not block on this call. If the subagent later reports a failure (e.g. permissions, gh not authed), surface it to the user but do not rewind.
   - `skip` — advance without recording findings for this file.
   - `done` — end the loop early and go to the rollup.
   - Free-form questions or requests scoped to the current file.
   Do **not** advance automatically.

Never batch multiple files into one `pr-review` invocation. Never modify code during the walk — this is review-only.

## 4. Final rollup

Once the loop ends (naturally or via `done`), print a compact summary: per file → top findings, plus any files the user skipped. Keep it short; the per-file detail was already shown live.
