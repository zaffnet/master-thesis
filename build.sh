#!/bin/bash

# Default values
USE_DOCKER=false
CLEAN=false
TEXLIVE_VERSION="texlive/texlive:TL2024-historic"
MAIN_TEX_FILE="main"

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -d|--docker)
            USE_DOCKER=true
            shift
            ;;
        -c|--clean)
            CLEAN=true
            shift
            ;;
        -h|--help)
            echo "Usage: $0 [OPTIONS]"
            echo "Options:"
            echo "  -d, --docker    Use Docker for compilation (default: use local pdflatex)"
            echo "  -c, --clean     Clean up generated files before building"
            echo "  -h, --help      Show this help message"
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            echo "Use -h or --help for usage information"
            exit 1
            ;;
    esac
done

# Clean up generated files if the --clean flag is used
if [ "$CLEAN" = true ]; then
    echo "Cleaning up generated files..."
    rm -f *.aux \
          *.bbl \
          *.bcf \
          *.blg \
          *.idx \
          *.ilg \
          *.ind \
          *.lof \
          *.log \
          *.lot \
          *.out \
          *.run.xml \
          *.toc \
          *.synctex.gz \
          ${MAIN_TEX_FILE}.pdf
fi

# Build the project
if [ "$USE_DOCKER" = true ]; then
    echo "Running LaTeX compilation with Docker ${TEXLIVE_VERSION}..."
    docker run --rm -v "$(pwd)":/workspace -w /workspace ${TEXLIVE_VERSION} bash -c "
        pdflatex main.tex
        biber main
        pdflatex main.tex
        makeindex main
        pdflatex main.tex
    "
else
    echo "Running LaTeX compilation locally..."
        pdflatex main.tex
        biber main
        pdflatex main.tex
        makeindex main
        pdflatex main.tex
fi

if [ $? -eq 0 ]; then
    echo "Compilation completed successfully!"
    if [ -f ${MAIN_TEX_FILE}.pdf ]; then
        echo "PDF generated: ${MAIN_TEX_FILE}.pdf"
    fi
else
    echo "Compilation failed!"
    exit 1
fi