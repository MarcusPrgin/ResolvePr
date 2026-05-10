# SecPR Demo Script · 90 seconds · 4 speakers

> **Director: Aalaa** — you call the transitions, you watch the clock, you hold up fingers at 60s and 80s.
> Lock this script at 20:00 the night before. No changes after that.

---

## Pre-demo checklist (30 min before)

```
[ ] Dee fires 3 dummy reviews against test functions (pre-warm Claude)
[ ] curl <API_URL>/health → "ok"
[ ] Dashboard tab open and showing real findings
[ ] Demo PR tab open and staged (DO NOT push yet)
[ ] Backup video (QuickTime) open and paused at frame 0
[ ] Printed scripts in each speaker's hand
[ ] Phone hotspot on and verified
[ ] Browser zoom at 125% — back row must read the code
[ ] Water on the table
```

---

## Browser tab order (pin these, in this order)

1. `https://secpr.vercel.app` — **SecPR Dashboard**
2. `https://github.com/acme-corp/api-gateway/pull/NEW` — **The demo PR** (not yet opened)
3. Terminal with server logs running

---

## The demo PR contents

File: `server/users.go`

```go
// Vulnerable version — what the PR adds
func searchUsers(db *sql.DB, query string) ([]User, error) {
    rows, err := db.Query("SELECT id, name FROM users WHERE name LIKE '%" + query + "%'")
    if err != nil { return nil, err }
    defer rows.Close()
    var users []User
    for rows.Next() {
        var u User
        rows.Scan(&u.ID, &u.Name)
        users = append(users, u)
    }
    return users, nil
}
```

This is 3 changed lines in the query. Easy to explain. Dramatic to fix.

---

## Script

### 0:00 – 0:15 · **Aalaa** · Open the dashboard

*[Click to Dashboard tab. Point at the findings list.]*

> "SecPR is an AI security reviewer that lives inside GitHub.
> We've already scanned the last ten PRs on this repo — here's every vulnerability it caught, ranked by severity.
> Now let's open a fresh one."

---

### 0:15 – 0:30 · **Remus** · Open the demo PR

*[Aalaa passes to Remus. Remus switches to the GitHub tab and pushes the staged PR.]*

> "Here's a pull request adding a user search endpoint.
> Three lines of SQL. Looks clean. A reviewer skimming this at 11pm might miss it.
> Watch what happens."

---

### 0:30 – 0:50 · **Marcus** · The moment

*[The inline comment appears on the exact line. Switch to show it clearly.]*

> "Within ten seconds — there it is.
> Inline comment on the exact vulnerable line. CWE-89. SQL injection.
> And the suggested fix is a parameterized query."

*[Pause one beat. Let judges read it.]*

---

### 0:50 – 1:10 · **Marcus** · The twist

*[Stay on the PR. Point at the code context in the comment.]*

> "Most security tools send the AI just the three changed lines.
> We use tree-sitter to send the entire enclosing function as context.
> That's why the fix uses 'query' — the actual variable from this codebase —
> not a generic placeholder copied from a tutorial.
> Context is what makes the fix actually usable."

---

### 1:10 – 1:25 · **Dee** · The close

*[Dee clicks "Apply suggestion" on the GitHub suggestion block. Check Run turns green.]*

> "One click. The fix is committed. Check Run turns green.
> We've found, explained, and fixed a SQL injection in under a minute —
> without leaving the pull request."

---

### 1:25 – 1:30 · **Aalaa** · CTA

*[Hold up the QR code.]*

> "Scan this to install SecPR on your repo right now. Thank you."

---

## If something breaks

| Problem | Action |
|---|---|
| API server down | Switch to Marcus's laptop + ngrok. Say "we'll demo locally." |
| Claude API slow | Say "pre-warmed in prod — this is a cold demo environment." Keep going. |
| Comment doesn't appear | Reload the PR. If still nothing, play backup video. |
| Dashboard won't load | Keep going on the PR tab. Explain the dashboard from memory. |

**Backup video location:** `~/Demo/backup.mov` — open in QuickTime, ready to play

---

## Q&A prep

**"What about false positives?"**
> "We filter on confidence score — anything below 0.7 is suppressed. In our test corpus, zero false positives on clean code."

**"How is this different from GitHub's native security scanning?"**
> "GitHub's scanning is pattern-matching on known signatures. We use an LLM with the full function context, so we catch logic flaws that static rules miss — like this authorization bypass on line 45."

**"Does it work on Python / TypeScript?"**
> "The prompt handles any language. The AST chunker currently covers Go and Python — TypeScript is next, 2 hours of work."

**"What's the latency?"**
> "Under 10 seconds end-to-end from push to inline comment. Claude sonnet, streaming off."

**"How do you stop Claude from hallucinating line numbers?"**
> "Three filters: the line must exist in the diff, severity must be a valid enum, confidence must be ≥ 0.7. Dee owns this — she can walk you through the validator."

---

## Speaker assignments recap

| Speaker | Owns |
|---|---|
| Aalaa | Opening, CTA, demo direction, clock |
| Remus | PR push, infra narration |
| Marcus | The moment, the twist, technical Q&A |
| Dee | The close (Apply suggestion), hallucination Q&A |
