#!/bin/bash

# === LaTeX Project Compilation Script ===
# Compiles LaTeX sources into compiled-pdfs/ preserving subdirectory structure
# Intermediate artifacts go to builds/
# Cleans build directories after successful compilation

set -e  # Stop on first error

# --- Directories ---
SOURCE_DIR="latex-notes"
BUILD_DIR="builds"
OUTPUT_DIR="compiled-pdfs"

# Ensure root directories exist
mkdir -p "$SOURCE_DIR" "$BUILD_DIR" "$OUTPUT_DIR"

# --- Helper: pretty print separator ---
print_separator() {
    echo "----------------------------------------"
}

# --- Compile a single .tex file ---
compile_tex() {
    local tex_file="$1"
    local abs_path
    abs_path=$(realpath "$tex_file")

    if [ ! -f "$abs_path" ]; then
        echo "❌ Source file not found: $abs_path"
        return 1
    fi

    # Compute relative path from SOURCE_DIR
    local rel_path
    rel_path=$(realpath --relative-to="$SOURCE_DIR" "$abs_path")

    # Determine directories for build and output
    local rel_dir
    rel_dir=$(dirname "$rel_path")
    local base_name
    base_name=$(basename "$abs_path" .tex)

    local build_subdir="$BUILD_DIR/$rel_dir/${base_name}_build"
    local final_pdf_dir="$OUTPUT_DIR/$rel_dir"

    mkdir -p "$build_subdir" "$final_pdf_dir"

    print_separator
    echo "🔧 Compiling: $abs_path"
    echo "   Build dir: $build_subdir"
    echo "   Output PDF dir: $final_pdf_dir"
    print_separator

    # Run LaTeX multiple times to resolve references
    pdflatex -interaction=nonstopmode -file-line-error -output-directory="$build_subdir" "$abs_path"
    pdflatex -interaction=nonstopmode -file-line-error -output-directory="$build_subdir" "$abs_path" >/dev/null 2>&1

    local build_pdf="$build_subdir/$base_name.pdf"
    local final_pdf="$final_pdf_dir/$base_name.pdf"

    if [ -f "$build_pdf" ]; then
        # Move PDF to final directory
        mv "$build_pdf" "$final_pdf"
        echo "✅ Successfully compiled → $final_pdf"

        # Cleanup build directory after success
        rm -rf "$build_subdir"
        echo "🧹 Cleaned temporary build dir: $build_subdir"
    else
        echo "❌ Compilation failed for $abs_path"
        return 1
    fi
}

# --- Main logic ---
if [ "$1" ]; then
    # Compile single file
    compile_tex "$1"
else
    # Compile all .tex files recursively
    echo "⚙️ No file specified — compiling all .tex files in $SOURCE_DIR recursively..."

    mapfile -t tex_files < <(find "$SOURCE_DIR" -type f -name "*.tex")
    if [ ${#tex_files[@]} -eq 0 ]; then
        echo "⚠️ No .tex files found in $SOURCE_DIR"
        exit 1
    fi

    for tex in "${tex_files[@]}"; do
        compile_tex "$tex"
    done
fi

print_separator
echo "✨ Done. All PDFs are in $OUTPUT_DIR/"
print_separator
