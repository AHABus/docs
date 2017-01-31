PDF			:= pandoc

PDF_DIR		:= ./pdf
SRC_DIR		:= ./src

MDS			:= $(wildcard $(SRC_DIR)/*.md) $(wildcard $(SRC_DIR)/*/*.md)
PDFS		:= $(patsubst $(SRC_DIR)/%.md, $(PDF_DIR)/%.pdf, $(MDS))

PDFFLAGS	:= -s -V geometry:margin=1in

.PHONY: doc clean

all: doc

doc: $(PDFS)

clean:
	@echo "cleaning output"
	@rm -rf $(PDF_DIR)

$(PDF_DIR)/%.pdf: $(SRC_DIR)/%.md
	@echo "compiling $(notdir $@)"
	@mkdir -p $(dir $@)
	@$(PDF) $(PDFFLAGS) -o $@ $<