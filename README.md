# TOEIC Learning

Vocabulary trainer for learners aiming for 700 or 900 on the TOEIC. Each learner picks a target in My Plan. Explanations are in English and Traditional Chinese (繁體中文).

## What is here

- `vocabulary/flashcards.html` is the learner page (single file, no server needed). It has My Plan, Study, Review (spaced repetition), Quiz (6 question types) and Mistakes. Progress is stored in each learner's own browser.
- `vocabulary/all-3000-words.json` is the full word data (field `lvl` is 700 or 900): 2000 core words (10 topics x 200, days 1-80) plus 1000 advanced words (10 topics x 100, days 81-120), 25 words a day.
- `vocabulary/advanced-900-words.json` holds only the 1000 advanced words; `advanced-900-selection.json` lists them with their source list (BSL, NAWL or NGSL).
- `vocabulary/all-2000-words-renumbered.json` is the 700-level core data (2000 words).
- `vocabulary/list-01-*.md` to `list-10-*.md` (and `.json`) are the per-topic lists.
- `vocabulary/study-plan.md` is the 10-week study plan.
- `vocabulary/source-TSL-1.2-wordlist.txt` and `source-BSL-1.2-wordlist.txt` are the word lists the 2000 words were chosen from.
- `vocabulary/all-2000-words-ai-generated-backup.json` is an earlier, AI-chosen 2000-word set kept as a backup.

## Phone app (redesign)

`docs/app/` is a redesigned, phone-first version of the trainer: a bottom tab bar (Today, Words, Quiz, Mistakes, Me), a daily task flow (new words, then due reviews, then a 10-question quiz), swipe cards, a streak and progress backup (export/import). It is an installable offline web app (PWA). With GitHub Pages serving `main` from `/docs`, it is at https://hoya-chen.github.io/toeic-learning/app/ . It uses the same browser storage keys as the earlier page, so progress made there carries over on the same site.

## How the 2000 words were chosen

All 1,249 words of the TOEIC Service List (TSL 1.2) plus 751 words from the Business Service List (BSL 1.2): BSL words that already had cards first, then the rest by everyday word frequency, after removing prefixes and words about war, politics and violence. The example sentences, pictures (emoji), Chinese meanings and related/confusable words were written separately, mostly in batches by AI, and have not all been reviewed by hand.

## How the 900 words were chosen

The 900 level adds 1000 words that are not in the 2000: 237 BSL words not already used, 159 words from the New Academic Word List (NAWL 1.2) and 604 harder words from the New General Service List (NGSL 1.2, mostly rank 1,000 and up). Words about war, politics, violence, natural science and very basic everyday words were removed; the rest were picked for business and workplace use. Cards were written in batches by AI and have not all been reviewed by hand. Topics for the 900 words are best-fit and balanced to 100 each, so some topic fits are loose.

## Credit

The TOEIC Service List, Business Service List, New Academic Word List and New General Service List are by Charles Browne and Brent Culligan (NAWL and NGSL with J. Phillips), from the New General Service List Project (http://www.newgeneralservicelist.org/), licensed under [Creative Commons Attribution-ShareAlike 4.0 International](http://creativecommons.org/licenses/by-sa/4.0/). Material derived from the lists must keep this credit and be shared under the same licence.
