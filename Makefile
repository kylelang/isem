# -*- Makefile -*-

## Find all constituent RMD files:
CHAPTERS = $(filter-out index.Rmd, $(wildcard *.Rmd))

VPATH = docs/

all: index.html syllabus.pdf assignments.pdf

## Update book:
# index.html: index.Rmd chapters
# 	Rscript -e "bookdown::render_book('$<', 'bookdown::gitbook', config_file = '_gitbook.yml')" 

## Update syllabus PDF:
syllabus.pdf: index.Rmd assignments.Rmd sections/assignments/*
	Rscript -e "bookdown::render_book('$<', output_format = 'bookdown::pdf_book')"

## Update assignment PDF:
# assignments.pdf: assignments.Rmd _assignments.yml
# 	Rscript -e "bookdown::render_book('$<', 'bookdown::pdf_book', config_file = '_assignments.yml')" 

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
	if [ -d ./isem_files ]; then rm -r isem_files; fi
	if [ -d ./isem_cache ]; then rm -r isem_cache; fi
	if [ -d ./assignment_guidelines_files ]; then rm -r assignment_guidelines_files; fi
	if [ -d ./assignment_guidelines_cache ]; then rm -r assignment_guidelines_cache; fi
	if [ -e ./pdf/assignment_guidelines.pdf ]; then rm pdf/assignment_guidelines.pdf; fi
	if [ -e ./pdf/syllabus.pdf ]; then rm pdf/syllabus.pdf; fi

clean:
	#if [ -d ./_bookdown_files ]; then rm -r ./_bookdown_files; fi
	#if [ -n "$(ls -A docs/*)" ]; then rm -r docs/*; fi
	if [ -e isem.Rmd ]; then rm isem.Rmd; fi
	if [ -e assignment_guidelines.Rmd ]; then rm assignment_guidelines.Rmd; fi
	if [ -e syllabus.Rmd ]; then rm sillabus.Rmd; fi
