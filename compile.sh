#!/bin/bash
# === LaTeX Project Compilation Script (with auto-refresh) ===
# Uses latexmk to compile .tex files and auto-refresh PDFs in VS Code
# Preserves subdirectory structure: builds/ for temp files, compiled-pdfs/ for output

set -e

SOURCE_DIR="/home/stu5/s0/acp7795/Documents/bit-to-brain/latex-notes"
BUILD_DIR="/home/stu5/s0/acp7795/Documents/bit-to-brain/builds"
OUTPUT_DIR="/home/stu5/s0/acp7795/Documents/bit-to-brain/compiled-pdfs"

mkdir -p "$SOURCE_DIR" "$BUILD_DIR" "$OUTPUT_DIR"

print_separator() {
    echo "----------------------------------------"
}

compile_tex() {
    local tex_file="$1"
    local abs_path
    abs_path=$(realpath "$tex_file")

    if [ ! -f "$abs_path" ]; then
        echo "❌ Source file not found: $abs_path"
        return 1
    fi

    local rel_path
    rel_path=$(realpath --relative-to="$SOURCE_DIR" "$abs_path")
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

    # Run latexmk with output to build directory but keep final PDF in OUTPUT_DIR
    # -pdf: compile to PDF
    # -interaction=nonstopmode: continue on errors
    # -output-directory: store intermediate files
    # -silent: reduce verbose output
    # -pvc: preview continuously (auto-recompile on .tex change)
    pdflatex -pdf -interaction=nonstopmode -output-directory="$build_subdir" \
        -auxdir="$build_subdir" \
        -jobname="$base_name" \
        -silent \
        "$abs_path"

    local build_pdf="$build_subdir/$base_name.pdf"
    local final_pdf="$final_pdf_dir/$base_name.pdf"

    if [ -f "$build_pdf" ]; then
        # Copy instead of move, so VS Code detects updates
        cp "$build_pdf" "$final_pdf"
        echo "✅ Successfully compiled → $final_pdf"
    else
        echo "❌ Compilation failed for $abs_path"
        return 1
    fi
}

if [ "$1" ]; then
    compile_tex "$1"
else
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
echo "✨ Done. PDFs are in $OUTPUT_DIR/"
print_separator

# #!/bin/bash
# # === LaTeX Project Compilation Script ===
# # Compiles LaTeX sources into compiled-pdfs/ preserving subdirectory structure
# # Intermediate artifacts go to builds/
# # Cleans build directories after successful compilation

# set +e

# SOURCE_DIR="/home/stu5/s0/acp7795/Documents/bit-to-brain/latex-notes"
# BUILD_DIR="/home/stu5/s0/acp7795/Documents/bit-to-brain/builds"
# OUTPUT_DIR="/home/stu5/s0/acp7795/Documents/bit-to-brain/compiled-pdfs"

# mkdir -p "$SOURCE_DIR" "$BUILD_DIR" "$OUTPUT_DIR"

# print_separator() {
#     echo "----------------------------------------"
# }

# compile_tex() {
#     local tex_file="$1"
#     local abs_path
#     abs_path=$(realpath "$tex_file")

#     if [ ! -f "$abs_path" ]; then
#         echo "❌ Source file not found: $abs_path"
#         return 1
#     fi

#     local rel_path
#     rel_path=$(realpath --relative-to="$SOURCE_DIR" "$abs_path")

#     local rel_dir
#     rel_dir=$(dirname "$rel_path")
#     local base_name
#     base_name=$(basename "$abs_path" .tex)

#     local build_subdir="$BUILD_DIR/$rel_dir/${base_name}_build"
#     local final_pdf_dir="$OUTPUT_DIR/$rel_dir"

#     mkdir -p "$build_subdir" "$final_pdf_dir"

#     print_separator
#     echo "🔧 Compiling: $abs_path"
#     echo "   Build dir: $build_subdir"
#     echo "   Output PDF dir: $final_pdf_dir"
#     print_separator

#     pdflatex -interaction=nonstopmode -file-line-error -output-directory="$build_subdir" "$abs_path"
#     pdflatex -interaction=nonstopmode -file-line-error -output-directory="$build_subdir" "$abs_path" >/dev/null 2>&1

#     local build_pdf="$build_subdir/$base_name.pdf"
#     local final_pdf="$final_pdf_dir/$base_name.pdf"

#     if [ -f "$build_pdf" ]; then
#         mv "$build_pdf" "$final_pdf"
#         echo "✅ Successfully compiled → $final_pdf"
#         rm -rf "$build_subdir"
#         echo "🧹 Cleaned temporary build dir: $build_subdir"
#     else
#         echo "❌ Compilation failed for $abs_path"
#         return 1
#     fi
# }

# if [ "$1" ]; then
#     compile_tex "$1"
# else
#     echo "⚙️ No file specified — compiling all .tex files in $SOURCE_DIR recursively..."
#     mapfile -t tex_files < <(find "$SOURCE_DIR" -type f -name "*.tex")
#     if [ ${#tex_files[@]} -eq 0 ]; then
#         echo "⚠️ No .tex files found in $SOURCE_DIR"
#         exit 1
#     fi
#     for tex in "${tex_files[@]}"; do
#         compile_tex "$tex"
#     done
# fi

# print_separator
# echo "✨ Done. All PDFs are in $OUTPUT_DIR/"
# print_separator
