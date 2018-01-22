# categorize numbers into different groups

cat <- function(x, lower = 0, start = 0, upper, by = 10,
                sep = "-", above.char = "+", below.char = "-") {
    
    labs <- c(paste(lower,below.char,start-1, sep = ""),
              paste(seq(start, upper - by, by = by),
                    seq(start + by - 1, upper - 1, by = by),
                    sep = sep),
              paste(upper, above.char, sep = ""))
    
    cut(floor(x), breaks = c(lower, seq(start, upper, by = by), Inf),
        right = FALSE, labels = labs) 
}
