send_OutlookMail <- function(to = to,
                             cc = cc,
                             title = title,
                             plots_path = plots_path,
                             html_formatFile = html_formatFile,
                             metric_list = metric_list
                             ) {
    library(dplyr)
    library(RDCOMClient)
    # create a new instance of the Outlook application
    OutApp <- COMCreate("Outlook.Application")
    outMail = OutApp$CreateItem(0)
    
    outMail[["To"]] = to
    outMail[["CC"]] = cc
    outMail[["subject"]] = title
    
    # attach plots
    plots_path <- paste0(plots_path,'/', list.files(path = plots_path, pattern = ".png"))
    
    for (a in plots_path) {
        plot_fullPath = a
        outMail[["Attachments"]]$Add(plot_fullPath) # to attach img into the HTML body
    }
    
    # build HTML body
    library(readtext)
    htmlbody <- readtext(html_formatFile)
    MyHTML <- htmlbody$text
    
    metric_list <- read.csv(metric_list, header = F, col.names = "variable", stringsAsFactors = F)$variable
    # update values in the html script
    for (l in metric_list) {
        patt <- l
        repl <- eval(parse(text = l)) %>% as.character() # extract value from string, str_replace function replace character only
        MyHTML <- str_replace(string = MyHTML, pattern = patt, replacement = repl)
    }
    
    outMail[["HTMLbody"]] =  MyHTML
    
    outMail$Send() # send mail    
}
