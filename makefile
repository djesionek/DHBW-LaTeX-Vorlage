# Name
NAME=fs$(shell pwd | tr / _)

# printf
PRINTF_CMD=$(shell which printf)
PRINTF_FORMAT="%17s %s \n"
PRINTF=$(PRINTF_CMD) $(PRINTF_FORMAT)

# latex engine
#LATEX_ENGINE=pdflatex
LATEX_ENGINE=xelatex

GLOSSARY_GEN=makeglossaries
BIBLIOGRAPHY_GEN=biber

# The command to remove something
RM_CMD=rm
RM_FLAGS=-f
RM=$(RM_CMD) $(RM_FLAGS)

MAKE_LOG=make.logs

# Files to compile
MAIN_FILE=ausarbeitung
MAIN_FILE_SUFFIX=tex

BIB_FILE=bibliographie
BIB_FILE_SUFFIX=bib

default: docker
	@$(PRINTF) "[docker]" "Starting container"
	@docker rm $(NAME) > /dev/null
	@docker run -it --name $(NAME) -e TARGET=_default -v $(shell pwd):/build djesionek/ubuntu-texlive

grimey: docker
	@$(PRINTF) "[docker]" "Starting container"
	@docker rm $(NAME) > /dev/null
	@docker run -it --name $(NAME) -e TARGET=_grimey -v $(shell pwd):/build djesionek/ubuntu-texlive

verbose: docker
	@$(PRINTF) "[docker]" "Starting container"
	@docker rm $(NAME) > /dev/null
	@docker run -it --name $(NAME) -e TARGET=_verbose -v $(shell pwd):/build djesionek/ubuntu-texlive

init: docker
	@$(PRINTF) "[docker]" "Creating container"
	@docker run -it --name $(NAME) -e TARGET=_default -v $(shell pwd):/build djesionek/ubuntu-texlive

enter: docker
	@$(PRINTF) "[docker]" "Entering container"
	@docker rm $(NAME) > /dev/null
	@docker run -it --name $(NAME) -e TARGET=_enter -v $(shell pwd):/build djesionek/ubuntu-texlive

_enter:
	@bash

_default: _grimey degrime

_grimey: $(BIB_FILE).$(BIB_FILE_SUFFIX) $(MAIN_FILE).$(MAIN_FILE_SUFFIX) #deckblatt.tex erklaerung.tex glossaries.tex content/*.tex 
	@$(PRINTF) "[make]" "Building quietly. Logs are written to $(MAKE_LOG)"
	@$(PRINTF) "[$(LATEX_ENGINE)]" "First run"
	@$(LATEX_ENGINE) -interaction=nonstopmode $(MAIN_FILE) > $(MAKE_LOG)
	@$(PRINTF) "[$(BIBLIOGRAPHY_GEN)]" "Creating bibliography"
	@$(BIBLIOGRAPHY_GEN) $(MAIN_FILE) >> $(MAKE_LOG)
	@$(PRINTF) "[$(GLOSSARY_GEN)]" "Creating glossaries"
	@$(GLOSSARY_GEN) $(MAIN_FILE) >> $(MAKE_LOG)
	@$(PRINTF) "[$(LATEX_ENGINE)]" "Second run"
	@$(LATEX_ENGINE) -interaction=nonstopmode $(MAIN_FILE) >> $(MAKE_LOG)
	@$(PRINTF) "[$(LATEX_ENGINE)]" "Third run"
	@$(LATEX_ENGINE) -interaction=nonstopmode $(MAIN_FILE) >> $(MAKE_LOG)

_verbose: $(BIB_FILE).$(BIB_FILE_SUFFIX) $(MAIN_FILE).$(MAIN_FILE_SUFFIX)
	@$(PRINTF) "[make]" "Building verbose"
	$(LATEX_ENGINE) $(MAIN_FILE)
	$(BIBLIOGRAPHY_GEN) $(MAIN_FILE)
	$(GLOSSARY_GEN) $(MAIN_FILE)
	$(LATEX_ENGINE) $(MAIN_FILE)
	$(LATEX_ENGINE) $(MAIN_FILE)

degrime:
	@$(PRINTF) "[$(RM_CMD)]" "Deleting temporary files"
	@$(RM) *.lof
	@$(RM) *.bbl
	@$(RM) *.toc
	@$(RM) *.aux
	@$(RM) *.bcf
	@$(RM) *.blg
	@$(RM) *.fdb_latexmk
	@$(RM) *.fls
	@$(RM) *.log
	@$(RM) *.run.xml
	@$(RM) *.lot
	@$(RM) *.ist
	@$(RM) *.glsdefs
	@$(RM) *.gls
	@$(RM) *.glo
	@$(RM) *.glg

clean: degrime
	@$(PRINTF) "[$(RM_CMD)]" "Deleting output files"
	@$(RM) *.pdf

docker:
	@$(PRINTF) "[make]" "Checking docker installation"
	@which docker > /dev/null
	@docker --version > /dev/null
	@docker ps > /dev/null

.PHONY: default grimey verbose _default _grimey _verbose degrime clean docker