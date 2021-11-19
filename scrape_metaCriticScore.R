library(tidyverse)
library(rvest)
library(httr)

# function to scrape element content
scrape_text <- function(htmlnodes, css_selector){
  
  text <- htmlnodes |>
    html_nodes(css = css_selector) |>
    html_text2()
  
  if (length(text) == 0) {
    text = NA
  }
  
  return(text)
}

# build empty dataframe to store data
meta_games_all <- data.frame()

for (i in 0:0) {
  page = paste0("https://www.metacritic.com/browse/games/score/metascore/all/all/filtered?page=", as.character(i))
  meta_html <- read_html(page)
  
  title_name <- meta_html |> 
    html_nodes(css = ".title  h3") |>
    html_text2()
  title_url <- meta_html |> 
    html_nodes(css = "td.clamp-image-wrap > a") |>
    html_attr("href")
  title_url_1 <- paste0("https://www.metacritic.com", title_url)
  
  publisher <- c()
  developer <- c()
  genre <- c()
  nbplayers <- c()
  rating <- c()
  platform <- c()
  platform_other <- c()
  releasedate <- c()
  metaScore <- c()
  userScore <- c()
  description <- c()
  
  for (j in 1:length(title_url_1)) {
    # game detail
    game <- read_html(title_url_1[j])
    
    # publisher
    publisher[j] = scrape_text(game, "li.summary_detail.publisher > span.data" )
    
    # developer
    developer[j] <- scrape_text(game, "li.summary_detail.developer > span.data" )

    # genre
    genre[j] <- scrape_text(game, "li.summary_detail.product_genre")

    # nbplayers
    nbplayers[j] <- scrape_text(game, "li.summary_detail.product_players")

    # rating
    rating[j] <- scrape_text(game, "li.summary_detail.product_rating > span.data")

    # platform
    platform[j] <- scrape_text(game,"div.product_title > span.platform")

    # platform_others
    platform_other[j] <- scrape_text(game,"li.summary_detail.product_platforms")

    # release date
    releasedate[j] <- scrape_text(game, "li.summary_detail.release_data > span.data")

    # meta score
    metaScore[j] <- scrape_text(game, "div.details.main_details > div > div > a > div > span") 

    # user score
    userScore[j] <- scrape_text(game, "div.details.side_details > div:nth-child(1) > div > a > div")

    # description
    title_description <- scrape_text(game, "div.details.main_details > ul > li > span.data > span > span.blurb.blurb_expanded")
    if (length(title_description) == 0) {
      title_description <-scrape_text(game, "div.details.main_details > ul > li > span.data > span")
    }
    description[j] <- title_description
    
  }
  
  mata_games <- data.frame(
    name = title_name, 
    releasedate = releasedate,
    metaScore = metaScore,
    userScore = userScore,
    url = title_url_1,
    publisher = publisher,
    developer = developer,
    genre = genre,
    nbplayers = nbplayers,
    rating = rating,
    platform = platform,
    platform_other = platform_other,
    description = description
  )
  
  meta_games_all <- rbind.data.frame(meta_games_all, mata_games)

}
