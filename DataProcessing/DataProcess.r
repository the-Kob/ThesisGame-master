#install.packages("dplyr", dep=TRUE, rep= "http://cran.uk.r-project.org")
#install.packages("maditr", dep=TRUE, rep= "http://cran.uk.r-project.org")
suppressMessages(library(dplyr))
suppressMessages(library(maditr))

events_csv = read.csv('Events.csv',
            header = TRUE, sep = ",", quote = "\"",dec = ".",
            fill = TRUE, comment.char = "")

res_csv = read.csv('Res.csv',
            header = TRUE, sep = ",", quote = "\"",dec = ".",
            fill = TRUE, comment.char = "")

# print(colnames(events_csv))

events_csv$companion_Type[events_csv$companion_Type=='0'] <- 'CompSC' 
events_csv$companion_Type[events_csv$companion_Type=='1'] <- 'CompSF' 
events_csv$companion_Type[events_csv$companion_Type=='2'] <- 'CompOC' 
events_csv$companion_Type[events_csv$companion_Type=='3'] <- 'CompOF'

resultsLog <- subset(events_csv, event_Type!="FINAL")

resultsLog <- resultsLog %>% 
    group_by(study_ID,companion_Type,event_Type,event_Actuator,event_Receiver) %>% 
    summarise(numEvents = n()) 

# print(head(finalEvents,5))
# q()
# print(resultsLog)

resultsLog <- dcast(resultsLog, study_ID ~ companion_Type+event_Type+event_Actuator+event_Receiver, value.var="numEvents")

finalEvents <- events_csv[events_csv$event_Type=='FINAL',]
finalEvents <- dcast(finalEvents, study_ID ~ companion_Type+event_Type, value.var = "score")
# print(finalEvents)
resultsLog <- merge(x=resultsLog,y=finalEvents,by=c('study_ID'))

resultsLog <- resultsLog %>%
    mutate(PLAYER_ACCURACY_CompOC = CompOC_HIT_PLAYER_PLAYER_ENEMY / (CompOC_HIT_PLAYER_PLAYER_ENEMY + CompOC_MISS_PLAYER_PLAYER_ENEMY))

resultsLog <- resultsLog %>%
    mutate(PLAYER_ACCURACY_CompOF = CompOF_HIT_PLAYER_PLAYER_ENEMY / (CompOF_HIT_PLAYER_PLAYER_ENEMY + CompOF_MISS_PLAYER_PLAYER_ENEMY))

resultsLog <- resultsLog %>%
    mutate(PLAYER_ACCURACY_CompSC = CompSC_HIT_PLAYER_PLAYER_ENEMY / (CompSC_HIT_PLAYER_PLAYER_ENEMY + CompSC_MISS_PLAYER_PLAYER_ENEMY))

resultsLog <- resultsLog %>%
    mutate(PLAYER_ACCURACY_CompSF = CompSF_HIT_PLAYER_PLAYER_ENEMY / (CompSF_HIT_PLAYER_PLAYER_ENEMY + CompSF_MISS_PLAYER_PLAYER_ENEMY))

# resultsLog <- resultsLog %>%
#     mutate(COMPANION_ACCURACY_CompSF = CompSF_HIT_PLAYER_PLAYER_ENEMY / (CompSF_HIT_COMPANION_COMPANION_ENEMY + CompSF_MISS_COMPANION_COMPANION_ENEMY))

# resultsLog <- resultsLog %>%
#     mutate(COMPANION_ACCURACY_CompSF = CompSF_HIT_PLAYER_PLAYER_ENEMY / (CompSF_HIT_COMPANION_COMPANION_ENEMY + CompSF_MISS_COMPANION_COMPANION_ENEMY))

# resultsLog <- resultsLog %>%
#     mutate(COMPANION_ACCURACY_CompSF = CompSF_HIT_PLAYER_PLAYER_ENEMY / (CompSF_HIT_COMPANION_COMPANION_ENEMY + CompSF_MISS_COMPANION_COMPANION_ENEMY))

# resultsLog <- resultsLog %>%
#     mutate(COMPANION_ACCURACY_CompSF = CompSF_HIT_PLAYER_PLAYER_ENEMY / (CompSF_HIT_COMPANION_COMPANION_ENEMY + CompSF_MISS_COMPANION_COMPANION_ENEMY))

# Deal with answers

interestVars <- colnames(res_csv)

for (i in 2:ncol(res_csv)){

    res_csv[,interestVars[i]][res_csv[,interestVars[i]] == '0 <not at all>'] <- 0
    res_csv[,interestVars[i]][res_csv[,interestVars[i]] == '1 <slightly>'] <- 1
    res_csv[,interestVars[i]][res_csv[,interestVars[i]] == '2 <moderately>'] <- 2
    res_csv[,interestVars[i]][res_csv[,interestVars[i]] == '3 <fairly>'] <- 3
    res_csv[,interestVars[i]][res_csv[,interestVars[i]] == '4 <extremely>'] <- 4
    res_csv[,interestVars[i]][res_csv[,interestVars[i]] == '1 <Not at all>'] <- 1
    res_csv[,interestVars[i]][res_csv[,interestVars[i]] == '2'] <- 2
    res_csv[,interestVars[i]][res_csv[,interestVars[i]] == '3 <Sometimes>'] <- 3
    res_csv[,interestVars[i]][res_csv[,interestVars[i]] == '4'] <- 4
    res_csv[,interestVars[i]][res_csv[,interestVars[i]] == '5 <Almost all of the time>'] <- 5
    res_csv[,interestVars[i]][res_csv[,interestVars[i]] == '1 <Extremely unpleasant>'] <- 1
    res_csv[,interestVars[i]][res_csv[,interestVars[i]] == '3'] <- 3
    res_csv[,interestVars[i]][res_csv[,interestVars[i]] == '4 <Neutral>'] <- 4
    res_csv[,interestVars[i]][res_csv[,interestVars[i]] == '6'] <- 6
    res_csv[,interestVars[i]][res_csv[,interestVars[i]] == '7 <Extremely pleasant>'] <- 7
    res_csv[,interestVars[i]][res_csv[,interestVars[i]] == '1 <not true at all>'] <- 1
    res_csv[,interestVars[i]][res_csv[,interestVars[i]] == '4 <somewhat true>'] <- 4
    res_csv[,interestVars[i]][res_csv[,interestVars[i]] == '7 <very true>'] <- 7
    res_csv[,interestVars[i]][res_csv[,interestVars[i]] == '1 <Extremely useless>'] <- 1
    res_csv[,interestVars[i]][res_csv[,interestVars[i]] == '2 <Somewhat useless>'] <- 2
    res_csv[,interestVars[i]][res_csv[,interestVars[i]] == '3 <Neither useful or useless>'] <- 3
    res_csv[,interestVars[i]][res_csv[,interestVars[i]] == '4 <Somewhat useful>'] <- 4
    res_csv[,interestVars[i]][res_csv[,interestVars[i]] == '5 <Extremely useful>'] <- 5
}

#res_csv$study_ID <- res_csv[colnames(res_csv)[[2]]]

#res_csv[,'study_ID'] <- as.numeric(unlist(res_csv[,'study_ID']))

resultsLog <- merge(x=resultsLog, y=res_csv, by=c('study_ID'))


write.csv(resultsLog, 'Events_processed.csv')