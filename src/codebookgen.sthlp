{smcl}
{* *! version 1.1 [07-07-2025] Md. Redoan Hossain Bhuiyan]}
{hline}
help for {bf:codebookgen}
{hline}

{title:Title}

{p2colset 5 18 20 2}{...}
{p2col :{cmd:codebookgen} {hline 2}}Enhanced codebook/documentation generator{p_end}
{p2colreset}{...}

{title:Syntax}

{p 8 17 2}
{cmd:codebookgen} 
[{varlist}] 
{cmd:using/}
[{cmd:,} 
{cmd:replace}
{cmd:modify}
{cmd:sheet(}{it:string}{cmd:)}
{cmd:addvars(}{it:string}{cmd:)}
{cmd:format}
{cmd:excelx}
]

{title:Description}

{pstd}
{cmd:codebookgen} creates comprehensive codebooks in Excel format with enhanced metadata handling.
It automatically extracts variable labels, value labels (when present), characteristics, 
and missing value statistics, producing professional documentation for your datasets.

{title:Options}

{phang}
{opt using} specifies the output Excel filename (required).

{phang}
{opt replace} overwrites an existing Excel file.

{phang}
{opt modify} appends to an existing Excel file (cannot combine with {opt replace}).

{phang}
{opt sheet(name)} specifies the worksheet name (default is "Codebook").

{phang}
{opt addvars(string)} lists additional characteristics to include as columns 
(e.g., "validation notes").

{phang}
{opt format} applies automatic formatting (column widths, header styling).

{phang}
{opt excelx} forces .xlsx format (default uses Stata's default Excel format).

{title:Output Structure}

{pstd}
The generated codebook includes these columns:

{p2colset 9 24 26 2}{...}
{p2col :Variable}Variable name{p_end}
{p2col :Label}Variable label{p_end}
{p2col :Question}Text from {cmd:char [note1]}{p_end}
{p2col :Type}Stata storage type{p_end}
{p2col :Values}Value labels (if defined) or range{p_end}
{p2col :Missing}Count of missing values{p_end}
{p2col :Obs}Count of non-missing values{p_end}
{p2colreset}{...}

{title:Examples}


{phang2}{cmd:. codebookgen using "auto_codebook.xlsx", replace format}{p_end}
{phang2}{cmd:. codebookgen make price mpg, using "auto_vars.xlsx", addvars(note1) replace}{p_end}
{phang2}{cmd:. codebookgen foreign, using "origin_codes.xlsx", sheet("Coding") replace}{p_end}



{title:Remarks}

{pstd}- For string variables, "Text" will appear in Values column{p_end}
{pstd}- For unlabeled numeric variables, min-max range is shown{p_end}
{pstd}- Only variables with labels are included by default{p_end}

{title:Author}

{pstd}[Md. Redoan Hossain Bhuiyan]{p_end}
{pstd}Email: {browse "mailto:redoanhossain630@gmail.com":redoanhossain630@gmail.com}{p_end}

{title:Also see}

{psee}
Manual: {help optcounts}, {help char}, {help biascheck}

{psee}
Online: {browse "https://www.stata.com/support/faqs/data-management/creating-codebooks/":Creating codebooks in Stata}
