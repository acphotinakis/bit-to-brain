import os

# Root project folder
root = "bit-to-brain"

# Class topics
classes = {
    "computer-networks": [
        "Introduction",
        "Application Layer",
        "Transport Layer",
        "Network Layer",
        "Link Layer",
        "Wireless and Mobile Networks + Security"
    ],
    "parallel-computing": [
        "Introduction and overview",
        "Parallelism, concurrency, and parallel computing",
        "SIMD, MIMD, SPMD, GPUs, MapReduce",
        "Analytical modeling of parallel programs",
        "Communication/computation costs",
        "Message Passing and MPI",
        "Parallel algorithms and programs",
        "Parallel machine learning algorithms",
        "Threads, processes, thread synchronization",
        "Shared memory, POSIX and OpenMP",
        "Parallel graph algorithms and programs",
        "Scheduling and load balancing",
        "Cloud and Edge Computing"
    ],
    "data-security-privacy": [
        # TBD topics
    ],
    "programming-language-concepts": [
        "Course Introduction, Project Introduction",
        "Programming Language Syntax (Tokenizing)",
        "Programming Language Syntax (Parsing)",
        "Functional Languages",
        "Scheme",
        "Data Abstraction",
        "SmallTalk",
        "Names, Scope, Binding",
        "Semantic Analysis",
        "Prolog / Logic Languages",
        "Control Flow",
        "Scripting Languages / Bash",
        "Type Systems",
        "Composite Types"
    ]
}

# Helper function to convert topic to filename
def topic_to_filename(topic):
    filename = topic.lower()
    filename = filename.replace("/", " ")
    filename = filename.replace("+", "plus")
    filename = filename.replace(",", "")
    filename = filename.replace("(", "").replace(")", "")
    filename = filename.replace("  ", " ")
    filename = "-".join(filename.split())
    return filename + ".tex"

# Function to create structure and files
def create_structure():
    try:
        os.makedirs(root, exist_ok=True)
        os.makedirs(os.path.join(root, "notes", "compiled"), exist_ok=True)
        os.makedirs(os.path.join(root, "code"), exist_ok=True)
        os.makedirs(os.path.join(root, "figures"), exist_ok=True)
        os.makedirs(os.path.join(root, "templates"), exist_ok=True)
        os.makedirs(os.path.join(root, "scripts"), exist_ok=True)

        for class_name, topics in classes.items():
            # Notes
            class_notes = os.path.join(root, "notes", class_name)
            os.makedirs(class_notes, exist_ok=True)
            topics_dir = os.path.join(class_notes, "topics")
            os.makedirs(topics_dir, exist_ok=True)
            os.makedirs(os.path.join(class_notes, "compiled"), exist_ok=True)

            # Create main tex
            main_tex = os.path.join(class_notes, f"{class_name}-main.tex")
            with open(main_tex, "w") as f:
                f.write(f"% Main LaTeX file for {class_name}\n")
                f.write("\\documentclass{article}\n")
                f.write("\\begin{document}\n")
                f.write(f"\\section*{{{class_name.replace('-', ' ').title()}}}\n")
                f.write("% Include topic files below\n")
                for topic in topics:
                    f.write(f"\\input{{topics/{topic_to_filename(topic)}}}\n")
                f.write("\\end{document}\n")

            # Create topic tex files
            for topic in topics:
                topic_file = os.path.join(topics_dir, topic_to_filename(topic))
                with open(topic_file, "w") as f:
                    f.write(f"% {topic}\n")
                    f.write("\\section*{" + topic + "}\n\n")
                    f.write("% Add content here\n")

            # Code directories
            class_code = os.path.join(root, "code", class_name)
            os.makedirs(os.path.join(class_code, "examples"), exist_ok=True)
            os.makedirs(os.path.join(class_code, "projects"), exist_ok=True)
            os.makedirs(os.path.join(class_code, "utils"), exist_ok=True)

        print("Project structure and LaTeX skeletons created successfully.")

    except Exception as e:
        print("Error occurred, rolling back changes...")
        import shutil
        if os.path.exists(root):
            shutil.rmtree(root)
        print(e)

if __name__ == "__main__":
    create_structure()
