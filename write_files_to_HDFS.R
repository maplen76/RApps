library(tidyverse)
library(httr)

### Parameters to set
# Url creation: Sirius WebHDFS url
hdfsUri <- "http://namenodedns:port/webhdfs/v1"

# Url creation: Url where you want to append the file
fileUri <- "/Projects/myfile.csv"

# Url creation: writeParameter
writeParameter <- "&op=CREATE"

# Url creation:Optional parameter, with the format &name1=value1&name2=value2
optionnalParameters <- "&overwrite=true"

# user name parameter
# https://hadoop.apache.org/docs/current/hadoop-project-dist/hadoop-hdfs/WebHDFS.html#Authentication
usernameParameter <- '?user.name=MYUSERNAME'

# Url creation: 
# Create the full url from all the parameters. The full url looks like this:
# http://namenodedns:port/webhdfs/v1/user/username/myfile.csv?user.name=MYUSERNAME&op=CREATE&overwrite=true
# Concatenate all the parameters into one uri, make sure user name included
uri <- paste0(hdfsUri, fileUri, usernameParameter, writeParameter, optionnalParameters)

# Ask the namenode on which datanode to write the file
response <- PUT(uri)

# Get the url of the datanode returned by hdfs
uriWrite <- response$url

# Uploading a file:In order to be uploaded, the data must be written on the disk. 
# If your data is already on the disk leave it that way, else you can write it with your favorite function, e.g.
data <- anno1800

# Write a temporary file on the disk
file.remove('tmp.csv')
write.csv(data, row.names = F, file = "tmp.csv")

# Upload the file with a PUT request
responseWrite <- PUT(uriWrite, body = upload_file("tmp.csv"))

# https://www.wikiwand.com/en/List_of_HTTP_status_codes
print(responseWrite[2]$status_code == 201)
