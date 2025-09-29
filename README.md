[![PDF (Cloudflare R2)](https://github.com/zaffnet/master-thesis/actions/workflows/release.yml/badge.svg?branch=main)](https://files.zafarmahmood.com/main.pdf)
# A Fully Generative Motivational Interviewing Chatbot for Moving Smokers Towards the Decision to Quit and LLM-Based Synthetic Smokers

**Author:** Zafarullah Mahmood

This repository contains the LaTeX source for my Master of Applied Science thesis at the University of Toronto.

## Abstract

Tobacco use is a leading cause of preventable death, yet many smokers lack access to effective cessation support like motivational interviewing (MI). This thesis presents the development and evaluation of a fully generative MI chatbot designed to help smokers move towards the decision to quit. The chatbot leverages large language models (LLMs) to provide empathetic, person-centered counseling, aiming to overcome barriers of cost, availability, and stigma associated with traditional therapy.

This work makes two primary contributions. First, it details the design and iterative refinement of the MI chatbot. Its effectiveness is assessed through an empirical study with human smokers, who provided qualitative feedback and self-reported their readiness to quit before and after interacting with the chatbot. Second, this thesis introduces a novel methodology for creating and validating *synthetic smokers*—LLM-powered agents that realistically simulate the demographic and behavioral characteristics of human smokers in MI conversations. A framework for evaluating the fidelity of these synthetic agents is presented, with results demonstrating their ability to approximate the conversational patterns of real smokers in controlled experiments.

Collectively, these contributions advance the field of AI-assisted mental health by offering a scalable, evidence-based tool for smoking cessation and by providing a new method for the low-cost, high-fidelity simulation of human subjects in behavioral research.

## Thesis Structure

The thesis is organized into the following chapters:

*   **Chapter 1: Introduction:** Introduces the problem of tobacco addiction, the potential of motivational interviewing, and the goals of the project.
*   **Chapter 2: Background:** Reviews the relevant literature on MI, LLMs, and chatbots for therapy.
*   **Chapter 3: MiBot: A Motivational Interviewing Chatbot:** Describes the design and implementation of the MI chatbot.
*   **Chapter 4: MiBot Evaluation:** Presents the results of an empirical study with human smokers.
*   **Chapter 5: Synthetic Smokers:** Details the methodology for creating LLM-based synthetic smokers.
*   **Chapter 6: Synthetic Smoker Evaluation:** Validates the synthetic smokers by comparing them to human smokers.
*   **Appendix:** Contains supplementary materials, including code.

## How to build this project and generate the PDF

**tl;dr**

```bash
chmod +x build.sh
./build.sh
```

This project can be built locally or using Docker. In either case, the `build.sh` script is the recommended way to build the PDF.

After cloning the repository, Jules changes the permissions of the `build.sh` script, so to make it executable:

```bash
chmod +x build.sh
```

### Using the Build Script

The `build.sh` script provides a convenient way to build the thesis. It supports local and Docker-based builds.

```bash
./build.sh [OPTIONS]
```

**Options:**

*   `-d`, `--docker`: Use Docker for compilation. This is the recommended method if you do not have a local LaTeX installation.
*   `-c`, `--clean`: Clean up all generated files before building. This includes the final PDF.
*   `-h`, `--help`: Show the help message.

### Local Build

To build the project locally, you need a working LaTeX distribution.

**Linux:**

On Debian-based distributions (like Ubuntu), you can install the necessary packages with the following command:

```bash
sudo apt-get install texlive-full
```

**macOS:**

On macOS, you can use [MacTeX](https://www.tug.org/mactex/).

Once you have a LaTeX distribution installed, you can build the PDF by running:

```bash
./build.sh
```

The build script will ensure that the required font package (`newtx`) is installed when `tlmgr` is available. If your
distribution does not provide `tlmgr`, install the `newtx` package manually before running the build.

### Docker Build

If you have Docker installed, you can build the project without installing LaTeX locally. This is the recommended method.

To build the PDF using Docker, run the following command:

```bash
./build.sh --docker
```

This will pull the necessary Docker image, install any missing TeX packages (including `newtx`), and compile the thesis. The
final PDF will be available in the root of the repository. A `Dockerfile` is included in the repository for reference.
