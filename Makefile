# -*- Makefile -*-

## Find all constituent RMD files:
CHAPTERS = $(filter-out index.Rmd, $(wildcard *.Rmd))

VPATH = docs/

all: index.html assignments

## Update book:
index.html: index.Rmd chapters
	Rscript -e "bookdown::render_book('$<', 'bookdown::gitbook', config_file = '_bookdown.yml')" 

## Update assignment PDF:
assignments: assignments.Rmd _pdf.yml
	Rscript -e "bookdown::render_book('$<', 'bookdown::pdf_book', config_file = '_pdf.yml')" 

## Update chapters:
chapters: $(CHAPTERS)
	Rscript render.R $?
	if [ ! -d ./docs ]; then mkdir docs; fi
	mv *.html docs/
	touch chapters

## Update sections:
%.Rmd: sections/%/* 
	touch $@

nuke: clean
	if [ -d ./docs ]; then rm -r docs; fi
	if [ -d ./tcsm_files ]; then rm -r tcsm_files; fi
	if [ -d ./tcsm_cache ]; then rm -r tcsm_cache; fi
	if [ -d ./assignment_guidelines_files ]; then rm -r assignment_guidelines_files; fi
	if [ -d ./assignment_guidelines_cache ]; then rm -r assignment_guidelines_cache; fi
	if [ -e ./pdf/assignment_guidelines.pdf ]; then rm pdf/assignment_guidelines.pdf; fi

clean:
	#if [ -d ./_bookdown_files ]; then rm -r ./_bookdown_files; fi
	#if [ -n "$(ls -A docs/*)" ]; then rm -r docs/*; fi
	if [ -e tcsm.Rmd ]; then rm tcsm.Rmd; fi
	if [ -e assignment_guidelines.Rmd ]; then rm assignment_guidelines.Rmd; fi
