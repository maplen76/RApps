# how to sent html mail with sendmialR package

library(sendmailR)
recipient <- c("xxx@xxx.com", "xxx@xxx.com")

from <- "xxx@xxxcom"
to <- recipient
bcc <- "xxx@xxx.com"
mailControl = list(smtpServer = "xxxxxx")

body <- paste0("<html>", 'test', "</html>")
subject <- 'test'

to_ <- "xxx@xxxcom"
msg <- mime_part(body)
msg[["headers"]][["Content-Type"]] <- "text/html"
        
sendmail(from=from, to=to_, bcc = bcc, subject=subject, msg=msg, control=mailControl)        
