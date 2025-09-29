#!/bin/bash

set -euo pipefail
trap 'echo "Compilation failed!" >&2' ERR

# Default values
USE_DOCKER=false
CLEAN=false
TEXLIVE_VERSION="ghcr.io/xu-cheng/texlive-debian:latest"
MAIN_TEX_FILE="main"
REQUIRED_TEX_PACKAGES=("newtx" "libertine" "inconsolata")

TLMGR_INSTALL_ARGS=""
if [ ${#REQUIRED_TEX_PACKAGES[@]} -gt 0 ]; then
    TLMGR_INSTALL_ARGS="${REQUIRED_TEX_PACKAGES[*]}"
fi

ensure_tex_packages() {
    if [ ${#REQUIRED_TEX_PACKAGES[@]} -eq 0 ]; then
        return 0
    fi

    if ! command -v tlmgr >/dev/null 2>&1; then
        echo "tlmgr command not found. Please ensure the following packages are available in your TeX distribution: ${REQUIRED_TEX_PACKAGES[*]}"
        return 0
    fi

    if [ ! -d "$HOME/texmf" ]; then
        echo "Initialising tlmgr user tree at $HOME/texmf"
        if ! tlmgr init-usertree; then
            cat <<'EOF' >&2
Warning: Failed to initialise tlmgr user tree; continuing without automatic package installation.
EOF
            return 0
        fi
    fi

    if [ -z "${TLMGR_REPOSITORY:-}" ]; then
        # Debian ships an older TeX Live; pin tlmgr to a matching historic repo to avoid cross-release errors.
        if tlmgr --version 2>/dev/null | grep -q "version 2023"; then
            TLMGR_REPOSITORY="https://ftp.math.utah.edu/pub/tex/historic/systems/texlive/2023/tlnet-final"
        fi
    fi

    if [ -n "${TLMGR_REPOSITORY:-}" ]; then
        tlmgr option repository "${TLMGR_REPOSITORY}" || {
            cat <<'EOF' >&2
Warning: Failed to set tlmgr repository; falling back to default mirror.
EOF
        }
    fi

    echo "Ensuring required TeX packages are installed: ${REQUIRED_TEX_PACKAGES[*]}"
    if ! tlmgr install "${REQUIRED_TEX_PACKAGES[@]}"; then
        cat <<'EOF' >&2
Warning: tlmgr failed to install the requested packages (perhaps user mode isn't initialised).
Continuing without automatic package installation; please ensure the packages are available manually if compilation fails.
EOF
    fi
}

run_with_pdflatex_pipeline() {
    pdflatex ${MAIN_TEX_FILE}.tex
    biber ${MAIN_TEX_FILE}
    pdflatex ${MAIN_TEX_FILE}.tex
    makeindex ${MAIN_TEX_FILE}
    pdflatex ${MAIN_TEX_FILE}.tex
}

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

DOCKER_INSTALL_COMMAND=":"
if [ -n "${TLMGR_INSTALL_ARGS}" ]; then
    DOCKER_INSTALL_COMMAND="tlmgr install ${TLMGR_INSTALL_ARGS}"
fi

DOCKER_COMPILE_COMMAND=$(cat <<EOF
set -euo pipefail
${DOCKER_INSTALL_COMMAND}
pdflatex ${MAIN_TEX_FILE}.tex
biber ${MAIN_TEX_FILE}
pdflatex ${MAIN_TEX_FILE}.tex
makeindex ${MAIN_TEX_FILE}
pdflatex ${MAIN_TEX_FILE}.tex
EOF
)

# Build the project
if [ "$USE_DOCKER" = true ]; then
    echo "Running LaTeX compilation with Docker ${TEXLIVE_VERSION}..."
    docker run --rm -e TEXLIVE_NO_DEFAULT_RECEIPT=1 -v "$(pwd)":/workspace -w /workspace ${TEXLIVE_VERSION} bash -c "
    latexmk -pdf -interaction=nonstopmode -halt-on-error main.tex
    "
else
    echo "Running LaTeX compilation locally..."
    ensure_tex_packages
    if command -v latexmk >/dev/null 2>&1; then
        latexmk -pdf -interaction=nonstopmode -halt-on-error ${MAIN_TEX_FILE}.tex
    else
        echo "latexmk not found; falling back to manual pdflatex/biber pipeline"
        run_with_pdflatex_pipeline
    fi
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
