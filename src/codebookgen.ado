*! codebookgen v1.1 -
*! Author: Md. Redoan Hossain Bhuiyan
*! Date: 08 July 2025

program define codebookgen
    version 16
    syntax [varlist] using/, [REPLACE MODIFY SHEET(name) ADDVars(string asis) FORMAT EXCELX]
    
    // Validate inputs
    if "`replace'" != "" & "`modify'" != "" {
        di as error "Cannot specify both replace and modify"
        exit 198
    }
    
    if "`sheet'" == "" local sheet "Codebook"
    
    // Default variables if none specified
    if "`varlist'" == "" {
        ds, has(varlabel)
        local varlist `r(varlist)'
    }
    
    // Set up Excel
    if "`excelx'" != "" {
        putexcel set "`using'", `replace' `modify' sheet("`sheet'")
    }
    else {
        putexcel set "`using'", `replace' `modify' sheet("`sheet'")
    }
    
    // Write headers (removed Source column)
    local headers Variable Label Question Type Values Missing Obs
    local col 1
    foreach h of local headers {
        putexcel `:word `col' of `c(ALPHA)''1 = "`h'", bold border(bottom)
        local ++col
    }
    
    // Add additional variable headers if specified
    if "`addvars'" != "" {
        foreach addvar in `addvars' {
            putexcel `:word `col' of `c(ALPHA)''1 = "`addvar'", bold border(bottom)
            local ++col
        }
    }
    
    // Initialize row counter
    local row 2
    
    // Process each variable
    foreach var of local varlist {
        // Basic info
        local varlab : var label `var'
        local vallab : value label `var'
        local chartxt : char `var'[note1]
        
        // Counts
        qui count if !missing(`var')
        local nonmiss = r(N)
        local miss = _N - r(N)
        
        // Variable type
        local type : type `var'
        
        // Get values - only show labels if they exist
        local values ""
        if "`vallab'" != "" {
            levelsof `var', local(vallevels)
            foreach val in `vallevels' {
                local lab : label `vallab' `val'
                local values `values' `val'=`lab'
            }
        }
        else if inlist("`type'", "byte", "int", "long", "float", "double") {
            qui sum `var'
            local values `r(min)' - `r(max)'
        }
        else if inlist("`type'", "str#") {
            local values "Text"
        }
        
        // Write to Excel
        putexcel A`row' = "`var'"
        putexcel B`row' = `"`varlab'"'
        putexcel C`row' = `"`chartxt'"'
        putexcel D`row' = "`type'"
        putexcel E`row' = `"`values'"'
        putexcel F`row' = `miss'
        putexcel G`row' = `nonmiss'
        
        // Add any additional variables
        if "`addvars'" != "" {
            local acol 8 // Start after standard columns (G is 7th column)
            foreach addvar in `addvars' {
                local addval : char `var'[`addvar']
                putexcel `:word `acol' of `c(ALPHA)''`row' = `"`addval'"'
                local ++acol
            }
        }
        
        local ++row
    }
    
    // Apply formatting if requested (removed wrap option)
    if "`format'" != "" {
        // Auto-size columns
        putexcel A1:`:word `=7+wordcount("`addvars'")' of `c(ALPHA)''1, ///
            hcenter bold border(bottom, thick)
        putexcel A2:`:word `=7+wordcount("`addvars'")' of `c(ALPHA)''`=`row'-1', ///
            hcenter
    }
    
    di as text "Codebook successfully generated in `using'"
end
