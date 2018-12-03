# categorize numbers into different groups

cat <- function(x, lower = 0, start = 0, upper, by = 2,
                sep = "-", above.char = "+", below.char = "-", Suff = "Month") {
    
    # start have to be greater than lower
    labs <- c(
        
        # build left beginning
        paste(lower, below.char, start, " ", Suff, sep = ""),
        
        # build middle intervals
        paste(
            seq(start + 1, upper - by + 1, by = by),
            paste0(seq(start + by, upper + 1, by = by), " ", Suff),
            sep = sep
        ),
        
        # build reight endpoint
        paste(upper + 1, above.char, " ", Suff, sep = "")
    )
    
    cut(
        floor(x), 
        breaks = c(lower, seq(start, upper, by = by), Inf),
        right = FALSE, 
        labels = labs
    ) 
}
