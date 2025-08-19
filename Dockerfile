# Use the official TeX Live image as a base
FROM texlive/texlive:TL2024-historic

# Set the working directory
WORKDIR /workspace

# Copy the entire project to the working directory
COPY . /workspace

# Set the default command to build the thesis
CMD ["bash", "build.sh"]
