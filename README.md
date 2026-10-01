# TOEIC Learning

Vocabulary trainer for learners aiming for about 700 on the TOEIC. Explanations are in English and Traditional Chinese (繁體中文).

## What is here

- `vocabulary/flashcards.html` is the learner page (single file, no server needed). It has My Plan, Study, Review (spaced repetition), Quiz (6 question types) and Mistakes. Progress is stored in each learner's own browser.
- `vocabulary/all-2000-words-renumbered.json` is the word data: 2000 words, 10 topics x 200 words, 80 study days x 25 words.
- `vocabulary/list-01-*.md` to `list-10-*.md` (and `.json`) are the per-topic lists.
- `vocabulary/study-plan.md` is the 10-week study plan.
- `vocabulary/source-TSL-1.2-wordlist.txt` and `source-BSL-1.2-wordlist.txt` are the word lists the 2000 words were chosen from.
- `vocabulary/all-2000-words-ai-generated-backup.json` is an earlier, AI-chosen 2000-word set kept as a backup.

## How the 2000 words were chosen

All 1,249 words of the TOEIC Service List (TSL 1.2) plus 751 words from the Business Service List (BSL 1.2): BSL words that already had cards first, then the rest by everyday word frequency, after removing prefixes and words about war, politics and violence. The example sentences, pictures (emoji), Chinese meanings and related/confusable words were written separately, mostly in batches by AI, and have not all been reviewed by hand.

## Credit

The TOEIC Service List and Business Service List are by Charles Browne and Brent Culligan, from the New General Service List Project (http://www.newgeneralservicelist.org/), licensed under [Creative Commons Attribution-ShareAlike 4.0 International](http://creativecommons.org/licenses/by-sa/4.0/). Material derived from the lists must keep this credit and be shared under the same licence.
