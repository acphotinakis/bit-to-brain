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

# Compile all .tex files in a directory (pass DIR=relative/path/to/dir)
.PHONY: dir
dir:
ifndef DIR
	$(error DIR is not set. Example: make dir DIR=latex-notes/computer-networks/topics)
endif
	@echo "⚙️  Compiling all .tex files under directory: $(DIR)"
	@find $(DIR) -type f -name "*.tex" | while read -r tex; do \
		$(COMPILE) "$$tex"; \
	done

# Clean build directories
.PHONY: clean
clean:
	@echo "🧹 Cleaning all builds and PDFs..."
	@rm -rf $(BUILD_DIR) $(OUTPUT_DIR)
	@mkdir -p $(BUILD_DIR) $(OUTPUT_DIR)
	@echo "✅ Cleaned $(BUILD_DIR) and $(OUTPUT_DIR)"

# Remove a single LaTeX file (PDF + build dir)
.PHONY: remove-file
remove-file:
ifndef FILE
	$(error FILE is not set. Example: make remove-file FILE=latex-notes/.../file.tex)
endif
	@echo "🗑️  Removing file: $(FILE)"
	@REL_PATH=$$(realpath --relative-to=$(SOURCE_DIR) $(FILE)); \
	BASE_NAME=$$(basename $$REL_PATH .tex); \
	BUILD_SUBDIR=$(BUILD_DIR)/$$(dirname $$REL_PATH)/$${BASE_NAME}_build; \
	OUTPUT_PDF=$(OUTPUT_DIR)/$$(dirname $$REL_PATH)/$${BASE_NAME}.pdf; \
	rm -rf "$$BUILD_SUBDIR" "$$OUTPUT_PDF"; \
	echo "✅ Removed $$OUTPUT_PDF and $$BUILD_SUBDIR"

# Remove all PDFs + builds under a directory
.PHONY: remove-dir
remove-dir:
ifndef DIR
	$(error DIR is not set. Example: make remove-dir DIR=latex-notes/computer-networks/topics)
endif
	@echo "🗑️  Removing all PDFs and builds under: $(DIR)"
	@find $(DIR) -type f -name "*.tex" | while read -r tex; do \
		REL_PATH=$$(realpath --relative-to=$(SOURCE_DIR) $$tex); \
		BASE_NAME=$$(basename $$REL_PATH .tex); \
		BUILD_SUBDIR=$(BUILD_DIR)/$$(dirname $$REL_PATH)/$${BASE_NAME}_build; \
		OUTPUT_PDF=$(OUTPUT_DIR)/$$(dirname $$REL_PATH)/$${BASE_NAME}.pdf; \
		rm -rf "$$BUILD_SUBDIR" "$$OUTPUT_PDF"; \
		echo "🗑️  Removed $$OUTPUT_PDF and $$BUILD_SUBDIR"; \
	done

# List all .tex files
.PHONY: list
list:
	@find $(SOURCE_DIR) -type f -name "*.tex"
