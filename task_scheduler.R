library(taskscheduleR)
library(dplyr)

# RCR
## run script to extract the exchange rate every Monday
taskscheduler_create(taskname = "xxxx",
                     rscript = "x:\\xxxxxx.R",
                     schedule = "WEEKLY",
                     starttime = "08:00",
                     days = "MON",
                     startdate = format(Sys.Date(), "%m/%d/%Y")  # note: have to keep the same date format as operating system
                     # note: set the path to 32 bit version because the default environment has been set to 32 bit
                     # when R updated, the path have to be updated, otherwise it will not work successfully
                     # update R 4.3.2 on 11/13/2017
                     ,Rexe = "x:\\PROGRA~1\\R\\R-34~1.2\\bin\\i386\\Rscript.exe"  # the folder inlcuding Rscript.exe
                     )
