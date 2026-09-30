ARTICLE := numeric-promotion-by-chained-visitors.md
# First-version date. Keep fixed across revisions; only PDF created advances.
ARTICLE_DATE := 2026-09-28
PDF := numeric-promotion-by-chained-visitors.pdf
PREAMBLE := preamble.tex
LOCAL_PREAMBLE := preamble-local.tex
STYLE := article-style.yaml
FIG_SRC := $(shell grep -l '^\\documentclass.*{standalone}' figures/*.tex 2>/dev/null)
FIG_INPUTS := $(wildcard figures/*.tex figures/*.sty)
FIG_ASSETS := $(wildcard figures/*.pdf figures/*.png figures/*.jpg figures/*.jpeg figures/*.svg figures/*.eps)
FIGURES := $(FIG_SRC:.tex=.pdf)
BUILD_DIR ?= build
BUILD_ABS := $(shell realpath -m -- "$(BUILD_DIR)")

.PHONY: pdf figures clean
pdf: $(PDF)
figures: $(FIGURES)

$(PDF): $(ARTICLE) $(PREAMBLE) $(LOCAL_PREAMBLE) $(STYLE) $(FIGURES) $(FIG_ASSETS) Makefile
	mkdir -p "$(BUILD_ABS)"
	printf '\\newcommand{\\pdfbuildtimestamp}{%s}\n' "$$(date -u '+%Y-%m-%d %H:%M:%S UTC')" > "$(BUILD_ABS)/pdf-build-time.tex"
	TMPDIR="$(BUILD_ABS)" pandoc "$(ARTICLE)" --from markdown+tex_math_dollars \
		--metadata date="$(ARTICLE_DATE)" \
		--metadata-file="$(STYLE)" --pdf-engine=xelatex --include-in-header="$(PREAMBLE)" \
		--include-in-header="$(LOCAL_PREAMBLE)" \
		--include-in-header="$(BUILD_ABS)/pdf-build-time.tex" -o "$@"

figures/%.pdf: figures/%.tex $(FIG_INPUTS)
	mkdir -p "$(BUILD_ABS)"
	cd figures && xelatex -interaction=nonstopmode -halt-on-error \
		-output-directory="$(BUILD_ABS)" "$*.tex" > /dev/null
	cp "$(BUILD_ABS)/$*.pdf" "$@"

clean:
	rm -rf -- "$(BUILD_ABS)"
