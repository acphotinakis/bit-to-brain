# Bit-to-Brain

**Bit-to-Brain** is an educational LaTeX notes project aimed at helping others learn both foundational and advanced computer science topics. The project organizes notes by subject, providing clear explanations and examples for complex topics in the field.

---

## 🎯 Project Goal

The goal of this project is to **share knowledge** by posting structured notes that cover:

- Core computer science subjects such as **Computer Networks**, **Parallel Computing**, **Data Security & Privacy**, and **Programming Language Concepts**.
- Practical, industry-relevant topics like network programming, MPI, and transport layer concepts.
- Concepts ranging from introductory to advanced, helping learners bridge the gap between coursework and real-world applications.

---

## 📂 Notes Structure

- `latex-notes/` – LaTeX source files organized by subject and topic:
  - **Computer Networks**
    - Application layer
    - Transport layer
  - **Data Security & Privacy**
  - **Parallel Computing**
    - Graph algorithms
    - MPI and process scheduling
  - **Programming Language Concepts**
- `builds/` – Temporary build artifacts for compilation.
- `compiled-pdfs/` – Final PDFs ready for reading, preserving the source directory structure.
- `compile.sh` – Script to compile LaTeX notes.
- `Makefile` – Convenient targets for building, cleaning, and managing notes.

---

## ⚡ Quick Usage

### Compile All Notes
```bash
./compile.sh
# or
make
````

### Compile a Single Note

```bash
./compile.sh latex-notes/computer-networks/topics/application-layer/additional-clarity-keywords.tex
# or
make compile FILE=latex-notes/computer-networks/topics/application-layer/additional-clarity-keywords.tex
```

### Clean All Builds and PDFs

```bash
make clean
```

### List All Notes

```bash
make list
```

---

## 🌟 Why Use This Project?

* **Structured Learning:** Notes are organized by subject and topic for easy navigation.
* **Industry Relevance:** Includes advanced topics that connect academic knowledge to practical applications.
* **Easy PDF Generation:** Build scripts and Makefile handle LaTeX compilation and output cleanly.
* **Open Knowledge Sharing:** Designed for others to read, learn, and build upon.

---

## 🔧 Requirements

* LaTeX distribution (e.g., TeX Live 2025)
* Bash shell
* Optional: `make` for simplified commands
