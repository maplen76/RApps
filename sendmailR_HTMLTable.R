library(xlsx)
library(dplyr)
library(htmlTable)

today <- Sys.Date()

path <- "//ubisoft.org/CTUStudio/Departments/BES_Team/Private/JIRADashboard/TrivialPursuit/"
file_df <- data.frame(file = list.files(path), stringsAsFactors = F) %>%
    mutate(date = str_extract(file,"\\d+\\.\\d+\\.\\d+"),
           date = as.Date(date, format = "%Y.%m.%d"),
           log = str_extract(file,"\\d+\\.\\d+\\.\\d+"),
           file_path = paste0(path, file)
           ) %>%
    filter(!is.na(date)) %>%
    arrange(desc(date))

l <- read.xlsx(file = file_df$file_path[1], stringsAsFactors = FALSE, sheetIndex = 1)
e <- read.xlsx(file = file_df$file_path[2], stringsAsFactors = FALSE, sheetIndex = 1)

max_sprint <- "Sprint " %>%
    paste0(max(as.numeric(str_extract(l$Sprint, "\\d+")) , na.rm = T) %>%
               as.character()
           )

f <- l %>%
    filter(Sprint == max_sprint) %>%
    group_by(Asignee) %>%
    summarise(timeSpent_l = round(sum(Time.Spent, na.rm = T), 1)) %>%
    ungroup() %>%
    left_join(e %>%
                  filter(Sprint == max_sprint) %>%
                  group_by(Asignee) %>%
                  summarise(timeSpent_e = round(sum(Time.Spent, na.rm = T), 1)) %>%
                  ungroup()
              ) %>%
    mutate(timeSpent_e = if_else(is.na(timeSpent_e), 0, timeSpent_e),
           logtime = if_else(timeSpent_e < timeSpent_l, "Logged", "Didn't Log"),
           timeLoged = timeSpent_l- timeSpent_e) %>%
    arrange(logtime, desc(timeSpent_l)) %>%
    select(Asignee,If_logged = logtime, timeLoged, timeSpent_l, timeSpent_e)

nb_groups <- f %>%
    group_by(If_logged) %>%
    summarise(n = n())

names(f) <- c("Asignee", "Status", "TimeLoged", file_df[1,3], file_df[2,3])

y <- htmlTable(f,
               tspanner  = c("Didn't Log", "Logged"),
               n.tspanner = c(nb_groups$n[1], nb_groups$n[2]),
               col.rgroup = c("none", "#F7F7F7"),
               css.table = "margin-top: 0.2em; margin-bottom: 0.2em; width: 80%;" )
body <- paste0("<html>", y, "</html>")

library(sendmailR)
from <- "ctu-trivialpursuit_all@ubisoft.com"
to <- "Xiao-Ling.Qiu@ubisoft.com"
cc <- "jing.wang@ubisoft.com"
subject <- paste0(nb_groups$n[1], '/', sum(nb_groups$n), " members didn't log time by ", file_df$log[1])
msg <- mime_part(body)
msg[["headers"]][["Content-Type"]] <- "text/html"
mailControl = list(smtpServer = "smtp-ncsa.ubisoft.org")
sendmail(from=from,to=to, cc = cc,subject=subject,msg=msg,control=mailControl)


# library(RDCOMClient)
# OutApp <- COMCreate("Outlook.Application")
# outMail <- OutApp$CreateItem(0)
# outMail[["SentOnBehalfOfName"]] = "jing.wang@ubisoft.com"
# outMail[["To"]] = "jing.wang@ubisoft.com"
# outMail[["subject"]] = paste0(nb_groups$n[1], '/', sum(nb_groups$n), " members didn't log time by ", file_df$date[1])
# outMail[["HTMLbody"]] = body
# outMail$Send()




