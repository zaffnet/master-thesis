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

## Building the PDF

To compile the thesis into a PDF, you will need a LaTeX distribution (e.g., TeX Live, MiKTeX) with `pdflatex` and `biber`. Run the following commands in the root of the repository:

```bash
pdflatex main.tex
biber main
pdflatex main.tex
pdflatex main.tex
```

This will generate a `main.pdf` file containing the complete thesis.
