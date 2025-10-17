# =========================
# Makefile for LaTeX Project
# =========================

# Variables
COMPILE=./compile.sh
SOURCE_DIR=latex-notes
BUILD_DIR=builds
OUTPUT_DIR=compiled-pdfs

# Default target: compile all
.PHONY: all
all:
	@echo "⚙️  Compiling all LaTeX files..."
	@$(COMPILE)

# Compile a single file (pass FILE=relative/path/to/file.tex)
.PHONY: compile
compile:
ifndef FILE
	$(error FILE is not set. Example: make compile FILE=latex-notes/.../file.tex)
endif
	@echo "⚙️  Compiling single file: $(FILE)"
	@$(COMPILE) $(FILE)

# Clean build directories
.PHONY: clean
clean:
	@echo "🧹 Cleaning all builds and PDFs..."
	@rm -rf $(BUILD_DIR) $(OUTPUT_DIR)
	@mkdir -p $(BUILD_DIR) $(OUTPUT_DIR)
	@echo "✅ Cleaned $(BUILD_DIR) and $(OUTPUT_DIR)"

# List all .tex files
.PHONY: list
list:
	@find $(SOURCE_DIR) -type f -name "*.tex"


.PHONY: dir
dir:
ifndef DIR
	$(error DIR is not set. Example: make dir DIR=latex-notes/computer-networks/topics)
endif
	@echo "⚙️ Compiling all .tex files under directory: $(DIR)"
	@find $(DIR) -type f -name "*.tex" | while read -r tex; do \
		$(COMPILE) "$$tex"; \
	done


# Optional: compile and open PDF of a single file
.PHONY: open
open:
ifndef FILE
	$(error FILE is not set. Example: make open FILE=latex-notes/.../file.tex)
endif
	@$(COMPILE) $(FILE)
	@PDF=$(OUTPUT_DIR)/$(shell basename $(FILE) .tex).pdf; \
	if [ -f $$PDF ]; then \
		echo "📖 Opening $$PDF"; \
		if command -v xdg-open >/dev/null 2>&1; then xdg-open $$PDF; \
		elif command -v open >/dev/null 2>&1; then open $$PDF; \
		else echo "⚠️ Could not open PDF automatically"; fi \
	fi
