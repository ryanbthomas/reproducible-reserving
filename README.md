
<!-- README.md is generated from README.Rmd. Please edit that file -->

# reproducible-reserving

<!-- badges: start -->

<!-- badges: end -->

Experiments that (hopefully) lead to an example workflow for actuarial
reserving using R/Rmarkdown.

## Why a workflow in R/Rmarkdown?

Spreadsheets currently dominate the workflows of actuaries and the
following pain points associated with them:

  - Single files make it difficult for the distributed teams of the
    modern workplace to work in parallel.
  - Spreadsheets are prone to reproducibility problems, as steps in
    analysis might be encoded several different ways (e.g., formula,
    macro, separate documentation, memory of analyst).
  - Logic and orchestration embedded in macros is often opaque and
    difficult to maintain.
  - Changes/errors may be difficult to spot because the model and view
    are on top of each other.
  - Once created, spreadsheet based workflows are often brittle to
    changes in methodology or implementation.

These are problems that can be addressed by moving to an R/RMarkdown
based workflow supported by distributed version control (git).

## Example

Since my primary goal is investigate workflow alternatives, my initial
example will be pretty simple, and consist of the following pieces:

  - Simulate incremental paid data using
    [{simulationmachine}](https://blog.kasa.ai/posts/simulation-machine/)
    package.
  - Clean, transform, filter, and aggregate claim data into form needed
    for analysis
  - Data Diagnostics (examples)
      - Large Claim movements
      - Actual vs Expected
  - Traditional reserve review including at least the following
      - Chainladder
      - BF
      - Cape Cod
      - Selection based on a rule (e.g. default method weights)
  - Report
      - Reserve Report (rmarkdown rendered to pdf)
      - Summary Tables (spreadsheet)
      - Deck for Board Presentation (rmarkdown rendered to slides)

Although this analysis is quite straightforward, one of the benefits of
an R/Rmarkdown workflow is the easy at which new methodologies can be
incorporated. I intend to demostrate this as this project evolves.

<!--
NOTE: This is okay content but not really what I want up on the README at the moement.
Every reserving role I've ever been in has had "the template". The Excel spreadsheet that was created by that one actuary who was really good with macros and building things. Who, incidently, hasn't worked at the organization in three years.

Whatever the provenance, this template gets reused in quarterly or annual reserve reviews, perhasp with some modifications. 
-->
