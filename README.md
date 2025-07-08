## codebookgen - Professional Data Documentation Tool for Stata


## Installation & use 

```stata
net install codebookgen, from("https://raw.githubusercontent.com/yourusername/codebookgen/main") replace
use "Dataset.dta", clear
codebookgen using "codebook.xlsx", replace
