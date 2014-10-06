TEX           = pdflatex
AUXFILES      = $(wildcard *.aux *.tmp *.toc *.xref *.lg *.idv *.dvi *.4tc *.4ct *.out *.log)
SOURCES       = $(wildcard *.tex)
PDFS          = $(SOURCES:.tex=.pdf)

.PHONY: rmaux pdf clean all

all: pdf

pdf: $(SOURCES) $(PDFS)

clean: rmaux
	rm -f $(PDFS) $(HTML)

rmaux:
	rm -f $(AUXFILES)

%.pdf: %.tex
	$(TEX) $<
