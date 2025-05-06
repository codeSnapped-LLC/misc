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
