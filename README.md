# reproducible-reserving
An example workflow for actuarial reserving using R/Rmarkdown

Spreadsheets currently dominate the workflows of actuaries, the following pain points associated with them:
• Single files make it difficult for the distributed teams of the modern workplace to work in parallel.
• Spreadsheets are prone to reproducibility problems, as steps in analysis might be encoded several
different ways (e.g., formula, macro, separate documentation).
• Logic and orchestration embedded in macros is often opaque and difficult to maintain.
• Changes/errors may be difficult to spot because the model and view are on top of each other.
• Once created, spreadsheet based workflows are often brittle to changes in methodology or implemen-
tation.
These are problems that can be addressed by moving to an R/RMarkdown based workflow supported by