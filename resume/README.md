# Markdown to PDF Resume Conversion with Docker

This guide explains how to convert a Markdown (`.md`) resume to a PDF using Docker. This approach provides a clean, repeatable, and dependency-free environment, perfect for consistent formatting and sharing resumes with Applicant Tracking Systems (ATS), recruiters, or hiring managers.

---

## Why Use This?

- **Consistency:** Ensure your resume looks the same on every machine.
- **Portability:** Easily share a Docker-based conversion setup with teammates or collaborators.
- **Simplicity:** No need to install Pandoc or LaTeX locally.
- **ATS-Friendly:** Convert Markdown resumes to clean, readable PDFs suitable for electronic parsing and submission.

---

## Prerequisites

- [Docker](https://www.docker.com/) installed on your system
- Your resume written in Markdown format (e.g., `resume.md`)

---

## Getting Started

### 1. Clone or Copy the Docker Setup

You’ll need two files:

#### Dockerfile

```
FROM pandoc/core:3.1-alpine

WORKDIR /data

COPY convert.sh /usr/local/bin/convert.sh
RUN chmod +x /usr/local/bin/convert.sh

ENTRYPOINT ["/bin/sh", "/usr/local/bin/convert.sh"]
```

#### convert.sh

```sh
#!/bin/sh

print_help() {
  cat << EOF
Usage: docker run --rm -v \$(pwd):/data pandoc-md2pdf [filename.md]

Converts a Markdown file to a PDF with the same base name.

Arguments:
  filename.md     The Markdown file to convert (must be in current directory)

If no argument is provided, the script will prompt for input.
EOF
}

convert_md_to_pdf() {
  input_file="$1"
  if [ ! -f "$input_file" ]; then
    echo "Error: File '$input_file' does not exist." >&2
    exit 1
  fi

  base_name=$(basename "$input_file" .md)
  pandoc "$input_file" -o "${base_name}.pdf"
  echo "Conversion complete: ${base_name}.pdf"
}

main() {
  if [ "$1" = "--help" ] || [ "$1" = "-h" ]; then
    print_help
    exit 0
  fi

  if [ -z "$1" ]; then
    echo -n "Enter the name of the Markdown file (e.g., resume.md): "
    read -r file_name
  else
    file_name="$1"
  fi

  convert_md_to_pdf "$file_name"
}

main "$@"
```

### 2. Build the Docker Image

```sh
docker build -t pandoc-md2pdf .
```

### 3. Convert Your Resume

**With argument:**

```sh
docker run --rm -v "$PWD":/data pandoc-md2pdf resume.md
```

**Interactive mode (prompts for file):**

```sh
docker run --rm -it -v "$PWD":/data pandoc-md2pdf
```

---

## Tips for ATS Compatibility

- Use clean Markdown with headings for sections like `## Experience`, `## Education`, etc.
- Avoid embedded images or non-standard fonts.
- Preview your Markdown resume before converting to ensure formatting is correct.

---

## Conclusion

This Dockerized Markdown-to-PDF setup is ideal for engineers and professionals who want a lightweight, reproducible way to generate professional resumes. It keeps your resume workflow in code, consistent with DevOps and documentation-as-code principles.
