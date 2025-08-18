# Clean first
rm -f *.aux *.log *.out *.toc *.lof *.lot

# Build
pdflatex main.tex
bibtex main
pdflatex main.tex
makeindex main
pdflatex main.tex