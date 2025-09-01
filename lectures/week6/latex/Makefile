# -*- Makefile -*-

TARGETS = sem.pdf
DEST = ../../../pdf/

all: $(TARGETS)
	
%.pdf: %.tex
	latexmk -pdf -f $^

%.tex: %.Rnw
	Rscript -e "knitr::knit('$^')"

.PHONY: clean tidy nuke

nuke: clean
	rm -f cache/* figure/* $(TARGETS)
	
tidy: clean
	mv $(TARGETS) $(DEST)
	
clean:
	rm -f *.tex *.aux *.log *.out *.nav *.snm *.toc *.vrb *.bbl *.blg *.fdb_latexmk *.fls
