#!/bin/bash

# Default values
USE_DOCKER=false
TEXLIVE_VERSION="texlive/texlive:TL2024-historic"

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -d|--docker)
            USE_DOCKER=true
            shift
            ;;
        -h|--help)
            echo "Usage: $0 [OPTIONS]"
            echo "Options:"
            echo "  -d, --docker    Use Docker for compilation (default: use local pdflatex)"
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

# Clean auxiliary files
rm -f *.aux *.log *.out *.toc *.lof *.lot

if [ "$USE_DOCKER" = true ]; then
    echo "Running LaTeX compilation with Docker ${TEXLIVE_VERSION}..."
    docker run --rm -v "$(pwd)":/workspace -w /workspace $TEXLIVE_VERSION bash -c "
        pdflatex main.tex
        bibtex main
        pdflatex main.tex
        makeindex main
        pdflatex main.tex
    "
else
    echo "Running LaTeX compilation locally..."
    pdflatex main.tex
    bibtex main
    pdflatex main.tex
    makeindex main
    pdflatex main.tex
fi

if [ $? -eq 0 ]; then
    echo "Compilation completed successfully!"
    if [ -f main.pdf ]; then
        echo "PDF generated: main.pdf"
    fi
else
    echo "Compilation failed!"
    exit 1
fi