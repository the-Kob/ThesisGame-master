library(dplyr)
library(readr)

df <- list.files(path='C:/Users/Pedro Bento/Desktop/Process Events/output') %>% lapply(read_csv) %>% bind_rows

write.csv(df, "EventsClean.csv", row.names = FALSE)