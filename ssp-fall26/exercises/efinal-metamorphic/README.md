## Metamorphic Testing for Package Hallucination Detection 

### Background 

Hallucinations are LLM-generated outputs that are factually incorrect and unrelated to the provided query. A package hallucination occurs when an LLM generates code, which  uses a package reference that does not exist. Researchers found popular LLMs to generate 205,474 hallucinated package names for 576,000 code snippets. Package hallucinations can be used by adversaries to conduct package confusion attacks, where adversaries can trick professionals in using a malicious package.

In this exercise, you will apply the idea of metamorphic relationships to detect hallucinated package names. You, yourself will generate hallucinated package names and then detect them using PyPI API's JSON. 

### Tasks 

- For each package names listed in `reqs.txt` 
  - Create a function that reports the status of each package using the [PyPI API](https://pypi.org/pypi/numpy/json). Save the output in `original.txt`
  - Generate five package names that are hallucinated by changing the names of the package. If you want you can use generative AI.  

- Create a function that can detect the changes in names of the original package. Repeat for all packages in `reqs.txt` 

- For each hallucinated package 
  - Create a function that reports the status of each package using the [PyPI API](https://pypi.org/pypi/numpy/json). Save the output in `hallucinated.txt`

- Create a file called `Explain.txt` where you will provide a mapping between the code snippets and `source test case`, `followup test case`, and `metamorphic relation`. 

### Deliverables 

- `original.txt`: 10%
- `hallucinated.txt`: 10%
- Code for the above tasks: 50%
- `Explain.txt`: 30% 