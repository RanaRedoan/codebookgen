*! codebookgen v1.0 - Enhanced codebook generator
*! Author: [Your Name]
*! Date: [Current Date]

program define codebookgen
    version 16
    syntax [varlist] using/, [REPLACE MODIFY SHEET(name) ADDVars(string asis) ///
                             STATS(string) FORMAT EXCELX]
    
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
    
    // Write headers
    local headers Variable Label Question Type Values Missing Obs Source Notes
    local col 1
    foreach h of local headers {
        putexcel `:word `col' of `c(ALPHA)''1 = "`h'", bold border(bottom)
        local ++col
    }
    
    // Initialize row counter
    local row 2
    
    // Process each variable
    foreach var of local varlist {
        // Basic info
        local varlab : var label `var'
        local vallab : value label `var'
        local chartxt : char `var'[note1]
        local source : char `var'[source]
        
        // Counts
        qui count if !missing(`var')
        local nonmiss = r(N)
        local miss = _N - r(N)
        
        // Variable type
        local type : type `var'
        
        // Get value labels if available
        if "`vallab'" != "" {
            levelsof `var', local(values)
            local vallist
            foreach val in `values' {
                local lab : label `vallab' `val'
                local vallist `vallist' `val'=`lab'
            }
            local values `vallist'
        }
        else if inlist("`type'", "byte", "int", "long", "float", "double") {
            qui tab `var', matcell(freq)
            local values `r(r)'
        }
        else if inlist("`type'", "str#") {
            local values "Text responses"
        }
        
        // Write to Excel
        putexcel A`row' = "`var'"
        putexcel B`row' = `"`varlab'"'
        putexcel C`row' = `"`chartxt'"'
        putexcel D`row' = "`type'"
        putexcel E`row' = `"`values'"'
        putexcel F`row' = `miss'
        putexcel G`row' = `nonmiss'
        putexcel H`row' = `"`source'"'
        
        // Add any additional variables
        if "`addvars'" != "" {
            local acol 9 // Start after standard columns
            foreach addvar in `addvars' {
                local addval : char `var'[`addvar']
                putexcel `:word `acol' of `c(ALPHA)''`row' = `"`addval'"'
                local ++acol
            }
        }
        
        local ++row
    }
    
    // Apply formatting if requested
    if "`format'" != "" {
        // Auto-size columns
        putexcel A1:`:word `=9+wordcount("`addvars'")' of `c(ALPHA)''1, ///
            hcenter bold border(bottom, thick)
        putexcel A2:`:word `=9+wordcount("`addvars'")' of `c(ALPHA)''`=`row'-1', ///
            hcenter wrap
    }
    
    di as text "Codebook successfully generated in `using'"
end