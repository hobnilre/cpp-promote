# Numeric Promotion by Chained Visitors

Recovering operand types for generic arithmetic in a C++ interpreter

## What this article adds, and why it matters

An interpreter holds values whose numeric kinds are known at runtime. A chained
visitor can recover both operand types and hand them to one ordinary C++ arithmetic
expression. The compiler selects the scalar result type; an overloaded factory
wraps it back into the interpreter's common value interface.

This article turns that connection into a practical design comparison. Chained
visitors, an explicit promotion table and C++17 variant visitation implement the
same arithmetic contract. Two concrete change requests—adding subtraction and
adding `long long`—show exactly what each design makes easy and what must change.
Short C++ examples, a dispatch diagram and complete result tables make the
comparison reproducible.

The resulting choice is concrete: visitors preserve an existing polymorphic
value interface, variant visitation simplifies this value-family extension, and
an explicit table exposes a separately maintained conversion policy. Each can
reuse arithmetic without handwritten bodies for every operand pair. GCC and
Clang checks cover all nine original and sixteen extended pairs for multiplication
and subtraction in each design. A separate dispatch argument, an alternative
division policy and a corrected acceptance cast identify the boundaries of the
construction. The article establishes engineering tradeoffs without claiming a
new dispatch mechanism or a measured speed advantage.

## Article and build

[Read the article (PDF)](numeric-promotion-by-chained-visitors.pdf) · [Manuscript source](numeric-promotion-by-chained-visitors.md)

Install GNU Make, GNU Coreutils, Pandoc, XeLaTeX and the TeX Gyre fonts, including the LaTeX
packages used by `preamble.tex` and `preamble-local.tex` and the TikZ/PGFPlots standalone figures.
Run `make pdf` from this repository. It regenerates changed figures and builds
the article without any sibling repository or private working files.

The first page gives the PDF creation time in UTC, followed by the
[GitHub repository](https://github.com/hobnilre/cpp-promote). An up-to-date PDF keeps its timestamp;
`make -B pdf` forces a rebuild. Intermediates go to ignored `build/` by default;
`BUILD_DIR=/absolute/path` selects another location. `make clean` removes that
build directory and keeps the published PDF and figure assets.

Shared typography is installed locally in `article-style.yaml`, `preamble.tex`
and `figures/figure-style.tex`. Article-specific definitions are in
`preamble-local.tex`. These files are complete build inputs; no tools checkout
is required.
