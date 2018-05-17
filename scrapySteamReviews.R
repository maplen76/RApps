
# steam reviews API: https://partner.steamgames.com/doc/store/getreviews

library(httr)
library(tidyverse)
setwd("D:\\R\\Rwd")
# Sys.setenv(https_proxy = "xxxxxxxxxx")
review <- data.frame()

url <- "https://store.steampowered.com/appreviews/359550?filter=recent&language=english&day_range=all&review_type=all&json=1&purchase_type=all&start_offset=20"
resp <- GET(url)
parsed <- jsonlite::fromJSON(content(resp, "text"), simplifyDataFrame = T, flatten = T)

df_review <- parsed$reviews %>% as.data.frame(stringsAsFactors = F )

review <- rbind(review, df_review)
