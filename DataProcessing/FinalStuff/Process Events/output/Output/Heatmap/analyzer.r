
# install.packages('ggplot2', dep=TRUE, repos = 'http://cran.us.r-project.org')
# install.packages('Rmisc', dep=TRUE, repos = 'http://cran.us.r-project.org')
# install.packages('reshape', dep=TRUE, repos = 'http://cran.us.r-project.org')
# install.packages('dplyr', dep=TRUE, repos = 'http://cran.us.r-project.org')
# install.packages('ggpubr', dep=TRUE, repos = 'http://cran.us.r-project.org')
# install.packages('stringi', dep=TRUE, repos = 'http://cran.us.r-project.org')
# install.packages('numbers', dep=TRUE, repos = 'http://cran.us.r-project.org')
# install.packages("scales", dep=TRUE, repos = 'http://cran.us.r-project.org')

suppressMessages(library(ggplot2))
suppressMessages(library(Rmisc))
suppressMessages(library(reshape))
suppressMessages(library(dplyr))
suppressMessages(library(readr))
suppressMessages(library(ggpubr))
suppressMessages(library('ggsci'))
suppressMessages(library(scales))
suppressMessages(library(numbers))


# suppressWarnings
# suppressMessages

csvs <- list.files(pattern = 'csv$')[[1]]
gameresultslog <- read.csv(file=csvs, header=TRUE, sep=',', stringsAsFactors=T)


colnames(gameresultslog)[1] <- 'timestamp'
colnames(gameresultslog)[2] <- 'check_playedBefore'
colnames(gameresultslog)[3] <- 'experimentID'
colnames(gameresultslog)[4] <- 'participantID'
colnames(gameresultslog)[5] <- 'age'
colnames(gameresultslog)[6] <- 'gender'
colnames(gameresultslog)[7] <- 'check_friendshipLevel'

colnames(gameresultslog)[8] <- 'howOftenPlays'
colnames(gameresultslog)[9] <- 'likesGameType'

colnames(gameresultslog)[10] <- 'Pre_Ind_Challenge'
colnames(gameresultslog)[11] <- 'Pre_Ind_Focus'
colnames(gameresultslog)[12] <- 'Pre_Group_Challenge'
colnames(gameresultslog)[13] <- 'Pre_Group_Focus'


levels(gameresultslog[,'howOftenPlays'])[levels(gameresultslog[,'howOftenPlays']) == 'I make some time in my schedule to play video games'] <- 3
levels(gameresultslog[,'howOftenPlays'])[levels(gameresultslog[,'howOftenPlays']) == 'I play video games occasionally when the opportunity presents itself'] <- 2
levels(gameresultslog[,'howOftenPlays'])[levels(gameresultslog[,'howOftenPlays']) == 'I do not play video games'] <- 1
gameresultslog[,'howOftenPlays'] <- as.numeric(gameresultslog[,'howOftenPlays'])

levels(gameresultslog[,'likesGameType'])[levels(gameresultslog[,'likesGameType']) == 'I enjoy them and have played/ watched others play them multiple times'] <- 3
levels(gameresultslog[,'likesGameType'])[levels(gameresultslog[,'likesGameType']) == 'I played/ watched others play them enough to understand I do not appreciate them'] <- 2
levels(gameresultslog[,'likesGameType'])[levels(gameresultslog[,'likesGameType']) == 'I am not familiar with these games and/or have no formed opinion on them'] <- 1
gameresultslog[,'likesGameType'] <- as.numeric(gameresultslog[,'likesGameType'])

interestVars <- c(
  'Pre_Ind_Challenge',
  'Pre_Ind_Focus',
  'Pre_Group_Challenge',
  'Pre_Group_Focus'
)

for (i in 1:4){
  levels(gameresultslog[,interestVars[i]])[levels(gameresultslog[,interestVars[i]]) == '1.'] <- 1
  levels(gameresultslog[,interestVars[i]])[levels(gameresultslog[,interestVars[i]]) == '1. ...the task provides an easy path for its completion.'] <- 1
  levels(gameresultslog[,interestVars[i]])[levels(gameresultslog[,interestVars[i]]) == '1.  ...be left alone to focus on the task.'] <- 1
  levels(gameresultslog[,interestVars[i]])[levels(gameresultslog[,interestVars[i]]) == '1.  ...following an easy path for completing the task.'] <- 1

  levels(gameresultslog[,interestVars[i]])[levels(gameresultslog[,interestVars[i]]) == '2.'] <- 2
  levels(gameresultslog[,interestVars[i]])[levels(gameresultslog[,interestVars[i]]) == '3.'] <- 3
  levels(gameresultslog[,interestVars[i]])[levels(gameresultslog[,interestVars[i]]) == '4.'] <- 4

  levels(gameresultslog[,interestVars[i]])[levels(gameresultslog[,interestVars[i]]) == '5.'] <- 5
  levels(gameresultslog[,interestVars[i]])[levels(gameresultslog[,interestVars[i]]) == '5.  ...interact with others, but also focus on the task.'] <- 5
  levels(gameresultslog[,interestVars[i]])[levels(gameresultslog[,interestVars[i]]) == '5.  ...interact with others, but also focus on the task.'] <- 5

  levels(gameresultslog[,interestVars[i]])[levels(gameresultslog[,interestVars[i]]) == '6.'] <- 6
  levels(gameresultslog[,interestVars[i]])[levels(gameresultslog[,interestVars[i]]) == '7.'] <- 7
  levels(gameresultslog[,interestVars[i]])[levels(gameresultslog[,interestVars[i]]) == '8.'] <- 8


  levels(gameresultslog[,interestVars[i]])[levels(gameresultslog[,interestVars[i]]) == '9.'] <- 9
  levels(gameresultslog[,interestVars[i]])[levels(gameresultslog[,interestVars[i]]) == '9. ...the task provides a difficult path for its completion.'] <- 9
  levels(gameresultslog[,interestVars[i]])[levels(gameresultslog[,interestVars[i]]) == '9.  ...interact with others, disregarding the task.'] <- 9
  levels(gameresultslog[,interestVars[i]])[levels(gameresultslog[,interestVars[i]]) == '9.  ...following a challenging path for completing the task.'] <- 9



  gameresultslog[,interestVars[i]] <- as.numeric(gameresultslog[,interestVars[i]])
}



# normalize pre-game challenge and focus
gameresultslog['Pre_Ind_Challenge'] <- (gameresultslog['Pre_Ind_Challenge'] - 1) / 8
gameresultslog['Pre_Ind_Focus'] <- (gameresultslog['Pre_Ind_Focus'] - 1) / 8

gameresultslog['Pre_Group_Challenge'] <- (gameresultslog['Pre_Group_Challenge'] - 1) / 8
gameresultslog['Pre_Group_Focus'] <- (gameresultslog['Pre_Group_Focus'] - 1) / 8



# tutorial data
suppressMessages(tutorialResults <- list.files(path='SynergiesExpResults/TUTORIAL/Results/', full.names = TRUE) %>%
  lapply(read_csv) %>%
  bind_rows)
  
  
colnames(tutorialResults)[1] <- 'experimentID'
colnames(tutorialResults)[2] <- 'participantID'
colnames(tutorialResults)[6] <- 'Tutorial_Score'
colnames(tutorialResults)[17] <- 'Tutorial_NumDeliveredRecipes'
colnames(tutorialResults)[22] <- 'Tutorial_TimeSpent'
tutorialResults <- tutorialResults %>% select(-(3:5),-(7:16),-(18:21))
suppressMessages(gameresultslog <- merge(x = gameresultslog, y = tutorialResults, by = c('experimentID','participantID')))
  



# training data
# synthesize Attempts into Training_Challenge
suppressMessages(trainingAttempts <- list.files(path='SynergiesExpResults/TRAINING/Attempts/', full.names = TRUE) %>%
  lapply(read_csv) %>%
  bind_rows)
  
colnames(trainingAttempts)[1] <- 'experimentID'
colnames(trainingAttempts)[2] <- 'participantID'

trainingAttemptsTotal <- trainingAttempts %>%
  group_by(experimentID,participantID) %>%
  summarize(Total_TimeSpent = sum(TimeSpent))


  
trainingAttempts <- merge(x = trainingAttemptsTotal, y = trainingAttempts, by = c('experimentID','participantID'))
trainingAttempts['Training_Challenge_Partial'] <- trainingAttempts['OrderLevel_AtEnd'] * (trainingAttempts['TimeSpent'] / trainingAttempts['Total_TimeSpent'])

trainingAttempts <- trainingAttempts %>%
  group_by(experimentID,participantID) %>%
  summarize(Training_Challenge = ((sum(Training_Challenge_Partial) - 1) / 4))
suppressMessages(gameresultslog <- merge(x = gameresultslog, y = trainingAttempts, by = c('experimentID','participantID')))




# synthesize Observations into Training_Focus
suppressMessages(trainingObservations <- list.files(path='SynergiesExpResults/TRAINING/ObservationsLog/', full.names = TRUE) %>%
  lapply(read_csv) %>%
  bind_rows)
colnames(trainingObservations)[3] <- 'experimentID'
colnames(trainingObservations)[4] <- 'participantID'


aux <- mapply('+', as.numeric(unlist(trainingObservations[5])),
  2*as.numeric(unlist(trainingObservations[6])))
aux2 <- mapply('+', aux,
    3*as.numeric(unlist(trainingObservations[7])))
trainingObservations['Raw_Focus'] <- aux2


trainingObservations <- trainingObservations %>%
  group_by(experimentID,participantID) %>%
  summarize(Training_Focus =
    ((mean(Raw_Focus) - 1) / 2)
  )
  
suppressMessages(gameresultslog <- merge(x = gameresultslog, y = trainingObservations, by = c('experimentID','participantID')))




# IMI data

# Interest/ Enjoyment
colnames(gameresultslog)[
  colnames(gameresultslog) %in% c(
  'X..I.enjoyed.doing.this.activity.very.much..',
  'X..This.activity.was.fun.to.do..',
  'X..I.thought.this.was.a.boring.activity..',
  'X..This.activity.did.not.hold.my.attention.at.all..',
  'X..I.would.describe.this.activity.as.very.interesting..',
  'X..I.thought.this.activity.was.quite.enjoyable..',
  'X..While.I.was.doing.this.activity..I.was.thinking.about.how.much.I.enjoyed.it..'
)] <- c(
  'IE1',
  'IE2',
  'IE3_R',
  'IE4_R',
  'IE5',
  'IE6',
  'IE7'
)

# Perceived Competence
colnames(gameresultslog)[
  colnames(gameresultslog) %in% c(
  'X..I.think.I.am.pretty.good.at.this.activity..',
  'X..I.think.I.did.pretty.well.at.this.activity..compared.to.other.students..',
  'X..After.working.at.this.activity.for.awhile..I.felt.pretty.competent..',
  'X..I.am.satisfied.with.my.performance.at.this.task..',
  'X..I.was.pretty.skilled.at.this.activity..',
  'X..This.was.an.activity.that.I.couldn.t.do.very.well..'
)] <- c(
  'PC1',
  'PC2',
  'PC3',
  'PC4',
  'PC5',
  'PC6_R'
)



interestVars <- c(
  'IE1',
  'IE2',
  'IE3_R',
  'IE4_R',
  'IE5',
  'IE6',
  'IE7',

  'PC1',
  'PC2',
  'PC3',
  'PC4',
  'PC5',
  'PC6_R'
)


for (i in 1:13){
  levels(gameresultslog[,interestVars[i]])[levels(gameresultslog[,interestVars[i]]) == '1. Not at all true'] <- 1
  levels(gameresultslog[,interestVars[i]])[levels(gameresultslog[,interestVars[i]]) == '2.'] <- 2
  levels(gameresultslog[,interestVars[i]])[levels(gameresultslog[,interestVars[i]]) == '3.'] <- 3
  levels(gameresultslog[,interestVars[i]])[levels(gameresultslog[,interestVars[i]]) == '4. Somewhat true'] <- 4
  levels(gameresultslog[,interestVars[i]])[levels(gameresultslog[,interestVars[i]]) == '5.'] <- 5
  levels(gameresultslog[,interestVars[i]])[levels(gameresultslog[,interestVars[i]]) == '6.'] <- 6
  levels(gameresultslog[,interestVars[i]])[levels(gameresultslog[,interestVars[i]]) == '7. Very true'] <- 7
  
  gameresultslog[,interestVars[i]] <- as.numeric(gameresultslog[,interestVars[i]]) 
}



gameresultslog['IMI_Interest_Enjoyment'] <-
  ((gameresultslog['IE1']
  + gameresultslog['IE2']
  + (8 - gameresultslog['IE3_R'])
  + (8 - gameresultslog['IE4_R'])
  + gameresultslog['IE5']
  + gameresultslog['IE6']
  + gameresultslog['IE7']
  ))/(7)

gameresultslog['IMI_Perceived_Competence'] <-
    ((gameresultslog['PC1']
    + gameresultslog['PC2']
    + gameresultslog['PC3']
    + gameresultslog['PC4']
    + gameresultslog['PC5']
    + (8 - gameresultslog['PC6_R'])
    ))/(6)


gameresultslog['Training_IMI_Engagement'] <- (gameresultslog['IMI_Interest_Enjoyment'] + gameresultslog['IMI_Perceived_Competence'])/2 
gameresultslog <- gameresultslog %>% select(-all_of(interestVars))





# survival data
suppressMessages(survivalResults <- list.files(path='SynergiesExpResults/SURVIVAL/Results/', full.names = TRUE) %>%
  lapply(read_csv) %>%
  bind_rows)
  

  
colnames(survivalResults)[1] <- 'experimentID'
colnames(survivalResults)[2] <- 'participantID'
colnames(survivalResults)[5] <- 'Survival_Score'

colnames(survivalResults)[6] <- 'Survival_NumDeliveredOrdersLVL1'
colnames(survivalResults)[7] <- 'Survival_NumDeliveredOrdersLVL2'
colnames(survivalResults)[8] <- 'Survival_NumDeliveredOrdersLVL3'
colnames(survivalResults)[9] <- 'Survival_NumDeliveredOrdersLVL4'
colnames(survivalResults)[10] <- 'Survival_NumDeliveredOrdersLVL5'

colnames(survivalResults)[16] <- 'Survival_NumDeliveredRecipesLVL1'
colnames(survivalResults)[17] <- 'Survival_NumDeliveredRecipesLVL2'
colnames(survivalResults)[18] <- 'Survival_NumDeliveredRecipesLVL3'
colnames(survivalResults)[19] <- 'Survival_NumDeliveredRecipesLVL4'
colnames(survivalResults)[20] <- 'Survival_NumDeliveredRecipesLVL5'

colnames(survivalResults)[21] <- 'Survival_TimeSpent'
survivalResults <- survivalResults %>% select(-(3:4),-(11:15))

suppressMessages(gameresultslog <- merge(x = gameresultslog, y = survivalResults, by = c('experimentID','participantID')))




#analyze data by experiment, not by individual
row_odd_aux <- seq_len(nrow(gameresultslog)) %% 2
row_odd <- (row_odd_aux == 1)
row_even <- (row_odd_aux == 0)
gameresultslogP1 <- gameresultslog[row_odd,]
gameresultslogP2 <- gameresultslog[row_even,]

divideProfile <- function(numLevelsPerDim, focusName, challengeName, processedDimName) {
   experimentslogByPlayer[processedDimName] <- 'NA'
   step <- 1/ numLevelsPerDim
   for(i in seq(0, (1 - step), by = step)){
    for(j in seq(0, (1 - step), by = step)){
      rightI <- i
      rightJ <- j
      leftI <- i
      leftJ <- j
      if(i==0) rightI = -1
      if(j==0) rightJ = -1
      if(i== (1 - step)) leftI = i + 0.1
      if(j== (1 - step)) leftJ = j + 0.1
      
      filteredData <- 
        experimentslogByPlayer[focusName] > rightI &  experimentslogByPlayer[focusName] <= leftI+step &
        experimentslogByPlayer[challengeName] > rightJ &  experimentslogByPlayer[challengeName] <= leftJ+step
      
      if(any(filteredData)){
        experimentslogByPlayer[filteredData,][processedDimName] <- i*numLevelsPerDim*numLevelsPerDim + j*numLevelsPerDim
      }
    }
  }
  return(experimentslogByPlayer)
}


divideProfile2 <- function(divFunction, focusName, challengeName, processedFocusName, processedChallengeName, processedDimName, prefix="") {
  experimentslogByPlayer[processedFocusName] <- 'NA'
  experimentslogByPlayer[processedChallengeName] <- 'NA'
  experimentslogByPlayer[processedDimName] <- 'NA'
  
  experimentslogByPlayer[processedFocusName] <- factor(experimentslogByPlayer[processedFocusName], levels=c(1,2))
  experimentslogByPlayer[processedChallengeName] <- factor(experimentslogByPlayer[processedChallengeName], levels=c(1,2))
  experimentslogByPlayer[processedDimName] <- factor(experimentslogByPlayer[processedDimName], levels=c(1,2,3,4))

  divChallenge <- divFunction(experimentslogByPlayer[,challengeName])
  divFocus <- divFunction(experimentslogByPlayer[,focusName])

  filteredData <- experimentslogByPlayer[challengeName] < divChallenge & experimentslogByPlayer[focusName] < divFocus
  if(any(filteredData)){
#     experimentslogByPlayer[filteredData,][processedFocusName] <- "1 - Self"
#     experimentslogByPlayer[filteredData,][processedChallengeName] <- "1 - Facilitate"
#     experimentslogByPlayer[filteredData,][processedDimName] <- paste(prefix,"Self Facilitator", sep='')
    experimentslogByPlayer[filteredData,][processedFocusName] <- 1
    experimentslogByPlayer[filteredData,][processedChallengeName] <- 1
    experimentslogByPlayer[filteredData,][processedDimName] <- 1
  }  
  filteredData <- experimentslogByPlayer[challengeName] >= divChallenge & experimentslogByPlayer[focusName] < divFocus
  if(any(filteredData)){
#     experimentslogByPlayer[filteredData,][processedFocusName] <- "1 - Self"
#     experimentslogByPlayer[filteredData,][processedChallengeName] <- "2 - Complicate"
#     experimentslogByPlayer[filteredData,][processedDimName] <- paste(prefix,"Self Challenger", sep='')
    experimentslogByPlayer[filteredData,][processedFocusName] <- 1
    experimentslogByPlayer[filteredData,][processedChallengeName] <- 2
    experimentslogByPlayer[filteredData,][processedDimName] <- 2
  }
  
  
  filteredData <- experimentslogByPlayer[challengeName] < divChallenge & experimentslogByPlayer[focusName] >=divFocus
  if(any(filteredData)){
#     experimentslogByPlayer[filteredData,][processedFocusName] <- "2 - Other"
#     experimentslogByPlayer[filteredData,][processedChallengeName] <- "1 - Facilitate"
#     experimentslogByPlayer[filteredData,][processedDimName] <- paste(prefix,"Others' Facilitator", sep='')
    experimentslogByPlayer[filteredData,][processedFocusName] <- 2
    experimentslogByPlayer[filteredData,][processedChallengeName] <- 1
    experimentslogByPlayer[filteredData,][processedDimName] <- 3
  }
  
  filteredData <- experimentslogByPlayer[challengeName] >= divChallenge & experimentslogByPlayer[focusName] >=divFocus
  if(any(filteredData)){
#     experimentslogByPlayer[filteredData,][processedFocusName] <- "2 - Other"
#     experimentslogByPlayer[filteredData,][processedChallengeName] <- "2 - Complicate"
#     experimentslogByPlayer[filteredData,][processedDimName] <- paste(prefix,"Others' Challenger", sep='')
    experimentslogByPlayer[filteredData,][processedFocusName] <- 2
    experimentslogByPlayer[filteredData,][processedChallengeName] <- 2
    experimentslogByPlayer[filteredData,][processedDimName] <- 4
  }
  
  
  return(experimentslogByPlayer)
}



return2 <- function(value){
  return(2)
}
return3 <- function(value){
  return(3)
}
divideVar2 <- function(divFunction, varName, processedVarName) {
  experimentslogByPlayer[processedVarName] <- 'NA'
  experimentslogByPlayer[processedVarName] <- factor(experimentslogByPlayer[processedVarName], levels=c(1,2))

  divVar <- divFunction(experimentslogByPlayer[,varName])

  filteredData <- (experimentslogByPlayer[varName] < divVar)
  
  if(any(filteredData)){
    experimentslogByPlayer[filteredData,][processedVarName] <- 1
  }  
  filteredData <- (experimentslogByPlayer[varName] >= divVar)
  if(any(filteredData)){
    experimentslogByPlayer[filteredData,][processedVarName] <- 2
  }
  
  return(experimentslogByPlayer)
}

divideVar3 <- function(varName, processedVarName) {
  experimentslogByPlayer[processedVarName] <- 'NA'
  experimentslogByPlayer[processedVarName] <- factor(experimentslogByPlayer[processedVarName], levels=c(1,2,3))

  var <- experimentslogByPlayer[,varName]
  step <- 1/3
  
  
  filteredData <- (experimentslogByPlayer[varName] >= 0 & experimentslogByPlayer[varName] < step)
  if(any(filteredData)){
    experimentslogByPlayer[filteredData,][processedVarName] <- 1
  }  
  filteredData <- (experimentslogByPlayer[varName] >= step & experimentslogByPlayer[varName] < 2*step)
  if(any(filteredData)){
    experimentslogByPlayer[filteredData,][processedVarName] <- 2
  }
  filteredData <- (experimentslogByPlayer[varName] >= 2*step & experimentslogByPlayer[varName] <= 3*step)
  if(any(filteredData)){
    experimentslogByPlayer[filteredData,][processedVarName] <- 3
  }
  
  return(experimentslogByPlayer)
}




experimentslogP1 <- merge(x = gameresultslogP1, y = gameresultslogP2, by = c('experimentID'), suffixes = c("_Self","_Other"))
experimentslogP2 <- merge(x = gameresultslogP2, y = gameresultslogP1, by = c('experimentID'), suffixes = c("_Self","_Other"))
experimentslogByPlayer <- rbind(experimentslogP1, experimentslogP2)

experimentslogByPlayer <- experimentslogByPlayer %>% select(-(15:16),-(23:33),-(47:48),-(55:65))


experimentslogByPlayer <- divideVar2(median, 'Tutorial_Score_Self', 'SkillLevel')
experimentslogByPlayer <- divideVar2(median, 'Tutorial_Score_Other', 'SkillLevel_Other')

experimentslogByPlayer <- divideVar2(median, 'check_friendshipLevel_Self', 'RelatednessLevel')
experimentslogByPlayer <- divideVar2(return2, 'howOftenPlays_Self', 'PlayFreqLevel')
experimentslogByPlayer <- divideVar2(return3, 'likesGameType_Self', 'GenreLikingLevel')


experimentslogByPlayer <- divideProfile2(median, 'Pre_Ind_Focus_Self', 'Pre_Ind_Challenge_Self', 'Profile_Est_Focus_Self', 'Profile_Est_Challenge_Self', 'Profile_Est_Self', 'Profile_Est_P1: ')
experimentslogByPlayer <- divideProfile2(median, 'Pre_Ind_Focus_Other', 'Pre_Ind_Challenge_Other', 'Profile_Est_Focus_Other', 'Profile_Est_Challenge_Other', 'Profile_Est_Other', 'Profile_Est_P2: ')
experimentslogByPlayer <- divideProfile2(median, 'Pre_Group_Focus_Self', 'Pre_Group_Challenge_Self', 'OptGroupProfile_Est_Focus_Self', 'OptGroupProfile_Est_Challenge_Self', 'OptGroupProfile_Est_Self')
experimentslogByPlayer <- divideProfile2(median, 'Pre_Group_Focus_Other', 'Pre_Group_Challenge_Other', 'OptGroupProfile_Est_Focus_Other', 'OptGroupProfile_Est_Challenge_Other', 'OptGroupProfile_Est_Other')
experimentslogByPlayer <- divideProfile2(median, 'Training_Focus_Self', 'Training_Challenge_Self', 'Training_Profile_Focus_Self', 'Training_Profile_Challenge_Self', 'Training_Profile_Self')
experimentslogByPlayer <- divideProfile2(median, 'Training_Focus_Other', 'Training_Challenge_Other', 'Training_Profile_Focus_Other', 'Training_Profile_Challenge_Other', 'Training_Profile_Other')



experimentslogByPlayer <- divideVar3('Pre_Ind_Focus_Self', 'Pre_Ind_Focus_Self_Div3')
experimentslogByPlayer <- divideVar3('Pre_Ind_Focus_Other', 'Pre_Ind_Focus_Other_Div3')
experimentslogByPlayer <- divideVar3('Pre_Group_Focus_Self', 'Pre_Group_Focus_Self_Div3')
experimentslogByPlayer <- divideVar3('Pre_Group_Focus_Other', 'Pre_Group_Focus_Other_Div3')
experimentslogByPlayer <- divideVar3('Training_Focus_Self', 'Training_Focus_Self_Div3')
experimentslogByPlayer <- divideVar3('Training_Focus_Other', 'Training_Focus_Other_Div3')

experimentslogByPlayer <- divideVar3('Pre_Ind_Challenge_Self', 'Pre_Ind_Challenge_Self_Div3')
experimentslogByPlayer <- divideVar3('Pre_Ind_Challenge_Other', 'Pre_Ind_Challenge_Other_Div3')
experimentslogByPlayer <- divideVar3('Pre_Group_Challenge_Self', 'Pre_Group_Challenge_Self_Div3')
experimentslogByPlayer <- divideVar3('Pre_Group_Challenge_Other', 'Pre_Group_Challenge_Other_Div3')
experimentslogByPlayer <- divideVar3('Training_Challenge_Self', 'Training_Challenge_Self_Div3')
experimentslogByPlayer <- divideVar3('Training_Challenge_Other', 'Training_Challenge_Other_Div3')


Training_Profile_Focus_Self_Num <- as.numeric(experimentslogByPlayer$Training_Profile_Focus_Self)
Training_Profile_Challenge_Self_Num <- as.numeric(experimentslogByPlayer$Training_Profile_Challenge_Self)
Training_Profile_Focus_Other_Num <- as.numeric(experimentslogByPlayer$Training_Profile_Focus_Other)
Training_Profile_Challenge_Other_Num <- as.numeric(experimentslogByPlayer$Training_Profile_Challenge_Other)

experimentslogByPlayer['Int_Training_Profile_Focus'] <- ((Training_Profile_Focus_Self_Num-1)*2 + (Training_Profile_Focus_Other_Num-1))+1
experimentslogByPlayer['Int_Training_Profile_Challenge'] <- ((Training_Profile_Challenge_Self_Num-1)*2 + (Training_Profile_Challenge_Other_Num-1))+1

experimentslogByPlayer$Int_Training_Profile_Focus <- as.factor(experimentslogByPlayer$Int_Training_Profile_Focus)
experimentslogByPlayer$Int_Training_Profile_Challenge <- as.factor(experimentslogByPlayer$Int_Training_Profile_Challenge)

Profile_Est_Focus_Self_Num <- as.numeric(experimentslogByPlayer$Profile_Est_Focus_Self)
Profile_Est_Challenge_Self_Num <- as.numeric(experimentslogByPlayer$Profile_Est_Challenge_Self)
Profile_Est_Focus_Other_Num <- as.numeric(experimentslogByPlayer$Profile_Est_Focus_Other)
Profile_Est_Challenge_Other_Num <- as.numeric(experimentslogByPlayer$Profile_Est_Challenge_Other)

experimentslogByPlayer['Int_Profile_Est_Focus'] <- ((Profile_Est_Focus_Self_Num-1)*2 + (Profile_Est_Focus_Other_Num-1))+1
experimentslogByPlayer['Int_Profile_Est_Challenge'] <- ((Profile_Est_Challenge_Self_Num-1)*2 + (Profile_Est_Challenge_Other_Num-1))+1

experimentslogByPlayer$Int_Profile_Est_Focus <- as.factor(experimentslogByPlayer$Int_Profile_Est_Focus)
experimentslogByPlayer$Int_Profile_Est_Challenge <- as.factor(experimentslogByPlayer$Int_Profile_Est_Challenge)

Int_OptGroupProfile_Est_Focus_Self_Num <- as.numeric(experimentslogByPlayer$OptGroupProfile_Est_Focus_Self)
Int_OptGroupProfile_Est_Challenge_Self_Num <- as.numeric(experimentslogByPlayer$OptGroupProfile_Est_Challenge_Self)
Int_OptGroupProfile_Est_Focus_Other_Num <- as.numeric(experimentslogByPlayer$OptGroupProfile_Est_Focus_Other)
Int_OptGroupProfile_Est_Challenge_Other_Num <- as.numeric(experimentslogByPlayer$OptGroupProfile_Est_Challenge_Other)

experimentslogByPlayer['Int_OptGroupProfile_Est_Focus'] <- ((Int_OptGroupProfile_Est_Focus_Self_Num-1)*2 + (Int_OptGroupProfile_Est_Focus_Other_Num-1))+1
experimentslogByPlayer['Int_OptGroupProfile_Est_Challenge'] <- ((Int_OptGroupProfile_Est_Challenge_Self_Num-1)*2 + (Int_OptGroupProfile_Est_Challenge_Other_Num-1))+1

experimentslogByPlayer$Int_OptGroupProfile_Est_Focus <- as.factor(experimentslogByPlayer$Int_OptGroupProfile_Est_Challenge)
experimentslogByPlayer$Int_OptGroupProfile_Est_Challenge <- as.factor(experimentslogByPlayer$Int_OptGroupProfile_Est_Challenge)

# experimentslogByPlayer['AbilityInc_Self'] <- experimentslogByPlayer['Survival_Score_Self'] - experimentslogByPlayer['Tutorial_Score_Self']
# experimentslogByPlayer['Training_IMI_Engagement_Self'] <- experimentslogByPlayer['Training_IMI_Engagement_Self']

# experimentslogByPlayer['AbilityInc_Other'] <- experimentslogByPlayer['Survival_Score_Other'] - experimentslogByPlayer['Tutorial_Score_Other']
# experimentslogByPlayer['Training_IMI_Engagement_Other'] <- experimentslogByPlayer['Training_IMI_Engagement_Other']



# compute team metrics
experimentslogByPlayer['Group_Survival_Score'] <- (experimentslogByPlayer['Survival_Score_Self'] + experimentslogByPlayer['Survival_Score_Other']) / 2
experimentslogByPlayer['Group_IMI_Interest_Enjoyment'] <- (experimentslogByPlayer['IMI_Interest_Enjoyment_Self'] + experimentslogByPlayer['IMI_Interest_Enjoyment_Other']) / 2
experimentslogByPlayer['Group_IMI_Perceived_Competence'] <- (experimentslogByPlayer['IMI_Perceived_Competence_Self'] + experimentslogByPlayer['IMI_Perceived_Competence_Other']) / 2





# compute similarity/complementarity according to profile pairs
experimentslogByPlayer['Int_Training_Profile_SimComp_Focus'] <- 'ND'
experimentslogByPlayer[,"Int_Training_Profile_SimComp_Focus"][experimentslogByPlayer[,"Int_Training_Profile_Focus"] == 1] <- 1
experimentslogByPlayer[,"Int_Training_Profile_SimComp_Focus"][experimentslogByPlayer[,"Int_Training_Profile_Focus"] == 2] <- 2
experimentslogByPlayer[,"Int_Training_Profile_SimComp_Focus"][experimentslogByPlayer[,"Int_Training_Profile_Focus"] == 3] <- 2
experimentslogByPlayer[,"Int_Training_Profile_SimComp_Focus"][experimentslogByPlayer[,"Int_Training_Profile_Focus"] == 4] <- 1
experimentslogByPlayer$Int_Training_Profile_SimComp_Focus <- as.factor(experimentslogByPlayer$Int_Training_Profile_SimComp_Focus)

experimentslogByPlayer['Int_Training_Profile_SimComp_Challenge'] <- 'ND'
experimentslogByPlayer[,"Int_Training_Profile_SimComp_Challenge"][experimentslogByPlayer[,"Int_Training_Profile_Challenge"] == 1] <- 1
experimentslogByPlayer[,"Int_Training_Profile_SimComp_Challenge"][experimentslogByPlayer[,"Int_Training_Profile_Challenge"] == 2] <- 2
experimentslogByPlayer[,"Int_Training_Profile_SimComp_Challenge"][experimentslogByPlayer[,"Int_Training_Profile_Challenge"] == 3] <- 2
experimentslogByPlayer[,"Int_Training_Profile_SimComp_Challenge"][experimentslogByPlayer[,"Int_Training_Profile_Challenge"] == 4] <- 1
experimentslogByPlayer$Int_Training_Profile_SimComp_Challenge <- as.factor(experimentslogByPlayer$Int_Training_Profile_SimComp_Challenge)


# exclude unacceptable tests
experimentslogByPlayer <- subset(experimentslogByPlayer, !(experimentID %in% c("F20")))


write.csv(experimentslogByPlayer,"./Output/byPlayerDataset.csv")

prefLevelOrder <- c(1,3,2,4)

experimentslogByPlayer[,"No_SigLab"] <- ''
experimentslogByPlayer[,"Training_Profile_Self_PC_SigLab"] <- 'a'
experimentslogByPlayer[,"Training_Profile_Self_SurvivalScore_SigLab"] <- 'a'
experimentslogByPlayer[,"Training_Profile_Other_SurvivalScore_SigLab"] <- 'a'
experimentslogByPlayer[,"Int_Training_Profile_Focus_SurvivalScore_SigLab"] <- 'a'


experimentslogByPlayer$Training_Profile_Self <- factor(experimentslogByPlayer$Training_Profile_Self, levels=prefLevelOrder)
experimentslogByPlayer$Training_Profile_Other <- factor(experimentslogByPlayer$Training_Profile_Other, levels=prefLevelOrder)


experimentslogByPlayer[,"Training_Profile_Self_PC_SigLab"][levels(experimentslogByPlayer[,"Training_Profile_Self"]) == 1] <- 'a'
experimentslogByPlayer[,"Training_Profile_Self_PC_SigLab"][levels(experimentslogByPlayer[,"Training_Profile_Self"]) == 2] <- 'b'
experimentslogByPlayer[,"Training_Profile_Self_PC_SigLab"][levels(experimentslogByPlayer[,"Training_Profile_Self"]) == 3] <- 'b'
experimentslogByPlayer[,"Training_Profile_Self_PC_SigLab"][levels(experimentslogByPlayer[,"Training_Profile_Self"]) == 4] <- 'a'


experimentslogByPlayer[,"Training_Profile_Self_SurvivalScore_SigLab"][levels(experimentslogByPlayer[,"Training_Profile_Self"]) == 1] <- 'a'
experimentslogByPlayer[,"Training_Profile_Self_SurvivalScore_SigLab"][levels(experimentslogByPlayer[,"Training_Profile_Self"]) == 2] <- 'b'
experimentslogByPlayer[,"Training_Profile_Self_SurvivalScore_SigLab"][levels(experimentslogByPlayer[,"Training_Profile_Self"]) == 3] <- 'a'
experimentslogByPlayer[,"Training_Profile_Self_SurvivalScore_SigLab"][levels(experimentslogByPlayer[,"Training_Profile_Self"]) == 4] <- 'a'


experimentslogByPlayer[,"Training_Profile_Other_SurvivalScore_SigLab"][levels(experimentslogByPlayer[,"Training_Profile_Other"]) == 1] <- 'a'
experimentslogByPlayer[,"Training_Profile_Other_SurvivalScore_SigLab"][levels(experimentslogByPlayer[,"Training_Profile_Other"]) == 2] <- 'a'
experimentslogByPlayer[,"Training_Profile_Other_SurvivalScore_SigLab"][levels(experimentslogByPlayer[,"Training_Profile_Other"]) == 3] <- 'b'
experimentslogByPlayer[,"Training_Profile_Other_SurvivalScore_SigLab"][levels(experimentslogByPlayer[,"Training_Profile_Other"]) == 4] <- 'b'


experimentslogByPlayer[,"Int_Training_Profile_Focus_SurvivalScore_SigLab"][levels(experimentslogByPlayer[,"Int_Training_Profile_Focus"]) == 1] <- 'a'
experimentslogByPlayer[,"Int_Training_Profile_Focus_SurvivalScore_SigLab"][levels(experimentslogByPlayer[,"Int_Training_Profile_Focus"]) == 2] <- ''
experimentslogByPlayer[,"Int_Training_Profile_Focus_SurvivalScore_SigLab"][levels(experimentslogByPlayer[,"Int_Training_Profile_Focus"]) == 3] <- 'a'
experimentslogByPlayer[,"Int_Training_Profile_Focus_SurvivalScore_SigLab"][levels(experimentslogByPlayer[,"Int_Training_Profile_Focus"]) == 4] <- 'b'



levels(experimentslogByPlayer[,"Training_Profile_Self"])[levels(experimentslogByPlayer[,"Training_Profile_Self"]) == 1] <- "Self-Facil."
levels(experimentslogByPlayer[,"Training_Profile_Self"])[levels(experimentslogByPlayer[,"Training_Profile_Self"]) == 2] <- "Self-Chall."
levels(experimentslogByPlayer[,"Training_Profile_Self"])[levels(experimentslogByPlayer[,"Training_Profile_Self"]) == 3] <- "Others-Facil."
levels(experimentslogByPlayer[,"Training_Profile_Self"])[levels(experimentslogByPlayer[,"Training_Profile_Self"]) == 4] <- "Others-Chall."


levels(experimentslogByPlayer[,"Training_Profile_Other"])[levels(experimentslogByPlayer[,"Training_Profile_Other"]) == 1] <- "Self-Facil."
levels(experimentslogByPlayer[,"Training_Profile_Other"])[levels(experimentslogByPlayer[,"Training_Profile_Other"]) == 2] <- "Self-Chall."
levels(experimentslogByPlayer[,"Training_Profile_Other"])[levels(experimentslogByPlayer[,"Training_Profile_Other"]) == 3] <- "Others-Facil."
levels(experimentslogByPlayer[,"Training_Profile_Other"])[levels(experimentslogByPlayer[,"Training_Profile_Other"]) == 4] <- "Others-Chall."


levels(experimentslogByPlayer[,"Int_Training_Profile_Focus"])[levels(experimentslogByPlayer[,"Int_Training_Profile_Focus"]) == 1] <- "S w/ S"
levels(experimentslogByPlayer[,"Int_Training_Profile_Focus"])[levels(experimentslogByPlayer[,"Int_Training_Profile_Focus"]) == 2] <- "S w/ O"
levels(experimentslogByPlayer[,"Int_Training_Profile_Focus"])[levels(experimentslogByPlayer[,"Int_Training_Profile_Focus"]) == 3] <- "O w/ S"
levels(experimentslogByPlayer[,"Int_Training_Profile_Focus"])[levels(experimentslogByPlayer[,"Int_Training_Profile_Focus"]) == 4] <- "O w/ O"


levels(experimentslogByPlayer[,"RelatednessLevel"])[levels(experimentslogByPlayer[,"RelatednessLevel"]) == 1] <- "Low"
levels(experimentslogByPlayer[,"RelatednessLevel"])[levels(experimentslogByPlayer[,"RelatednessLevel"]) == 2] <- "High"

levels(experimentslogByPlayer[,"PlayFreqLevel"])[levels(experimentslogByPlayer[,"PlayFreqLevel"]) == 1] <- "Does Not Play"
levels(experimentslogByPlayer[,"PlayFreqLevel"])[levels(experimentslogByPlayer[,"PlayFreqLevel"]) == 2] <- "Plays"

levels(experimentslogByPlayer[,"GenreLikingLevel"])[levels(experimentslogByPlayer[,"GenreLikingLevel"]) == 1] <- "No/No Opinion"
levels(experimentslogByPlayer[,"GenreLikingLevel"])[levels(experimentslogByPlayer[,"GenreLikingLevel"]) == 2] <- "Yes"


standard_error <- function(x) sd(x) / sqrt(length(x)) 

labelSize <- 10
computeBoxPlot <- function(var, metric, sigLab, varName, metricName, pathName, 
charToAddInLegend="", hasAngledXAxis = FALSE, hasUpOrDown = FALSE, 
hasModifiedLims = FALSE, yLimInf = 0, yLimSup= 1, yBy=1){

  upOrDown <- 0
  if(hasUpOrDown){
    upOrDown <- as.integer(experimentslogByPlayer[,deparse(substitute(var))]) 
    upOrDown <- mod(upOrDown,2)
  }

  metricAsArray <- experimentslogByPlayer[,deparse(substitute(metric))]
  allMeans <- group_by(experimentslogByPlayer, {{var}}) %>% summarize(mean = mean({{metric}}), sd = sd({{metric}}), se = standard_error({{metric}}), count = length({{metric}}))
 
  scaleSpan <- max(metricAsArray) - min(metricAsArray)
  scaleSpanWMargin <- min(min(metricAsArray) + 0.7*scaleSpan,0.8*scaleSpan)

  if(charToAddInLegend=="K"){
    allMeans$mean <- allMeans$mean/1000
    allMeans$sd <- allMeans$sd/1000
  }
  
  p <- ggplot(experimentslogByPlayer, aes(x={{var}}, y={{metric}})) + 
    stat_boxplot(geom = "errorbar", width=0.2, lwd=1) + 
    geom_boxplot(fill="#7d00bc", color="black", width=0.3, lwd=1) +
    theme(plot.title = element_text(size=labelSize*1.6), legend.text = element_text(size=labelSize), axis.text = element_text(size = labelSize*1.8), axis.title = element_text(size = labelSize*1.8, face = "bold"), legend.title = element_blank(), legend.position = 'bottom') + 
    guides(col = guide_legend(ncol = 2)) + 
    xlab(varName) + ylab(metricName) + 
    geom_text(data = experimentslogByPlayer, aes(x = {{var}}, y = mean({{metric}}), label = {{sigLab}}[{{var}}]), 
      nudge_x = -0.3, 
      nudge_y = 0, 
      size = 8) + 
    geom_text(data = experimentslogByPlayer, aes(x = {{var}}, y = mean({{metric}}) +0.5+0.35*upOrDown*scaleSpan, label = paste('n=', allMeans$count[{{var}}], '\n(', format(round(allMeans$mean[{{var}}], 2), nsmall = 1),charToAddInLegend, ' ± ', format(round(allMeans$sd[{{var}}], 2), nsmall = 1),charToAddInLegend,')', sep='')), 
      nudge_x = 0, 
      nudge_y = scaleSpanWMargin, 
      size = 5.2, hjust = 0.5, inherit.aes = TRUE, fontface = "bold") + 
    scale_x_discrete(expand = expansion(add = 0.9))

    if(hasModifiedLims){
      p <- p + scale_y_continuous(expand = expansion(mult = 0.2), labels = scales::label_number(scale_cut = scales::cut_short_scale()), limits = c(yLimInf, NA), breaks=seq(yLimInf, yLimSup,by=yBy))
    }else{
      p <- p + scale_y_continuous(expand = expansion(mult = 0.2), labels = scales::label_number(scale_cut = scales::cut_short_scale()), limits = c(0, NA))
    }
    
    if(hasAngledXAxis){
      p <- p + theme(axis.text.x =  element_text(vjust = 0.5, angle = 30))
    }
    
    ggsave(paste("Output/Plots/BoxPlots/", pathName, ".png", sep=''), height=5, width=6, units="in", dpi=300)
}


computeFreqHeatMap <- function(var1, var2, var1Name, var2Name, pathName){
  ## convert to tibble, add row identifier, and shape "long" 
  ## (from: https://stackoverflow.com/questions/14290364/create-heatmap-with-values-from-matrix-in-ggplot2, accessed 01-06-23)
  tb <- table(experimentslogByPlayer[,deparse(substitute(var1))], experimentslogByPlayer[,deparse(substitute(var2))])
  freqs <- data.frame(tb, row.names=NULL) 
  colnames(freqs) <- c("var1Val","var2Val","freqVal")
  
  levels(freqs[,"var1Val"])[levels(freqs[,"var1Val"]) == 1] <- "Low"
  levels(freqs[,"var1Val"])[levels(freqs[,"var1Val"]) == 2] <- "Med."
  levels(freqs[,"var1Val"])[levels(freqs[,"var1Val"]) == 3] <- "High"
  
  levels(freqs[,"var2Val"])[levels(freqs[,"var2Val"]) == 1] <- "Low"
  levels(freqs[,"var2Val"])[levels(freqs[,"var2Val"]) == 2] <- "Med."
  levels(freqs[,"var2Val"])[levels(freqs[,"var2Val"]) == 3] <- "High"
  
  p <- ggplot(freqs, aes(x=var1Val, y=var2Val)) +
    geom_tile(aes(fill = freqVal), color = "black", lwd = 1.5, linetype = 1) +
    geom_text(aes(label = round(freqVal, 1)), size = 15, colour = "black") +
    theme(plot.title = element_text(size=27), legend.text = element_text(size=27), axis.text = element_text(size = 27), axis.title = element_text(size = 27, face = "bold"), legend.title = element_blank(), legend.position = 'bottom') + 
    xlab(var1Name) + ylab(var2Name) + 
    scale_fill_gradient(low="white",high="#7d00bc",guide="none", breaks=c(0,2,5))
  ggsave(paste("Output/Plots/HeatMaps/", pathName, ".png", sep=''), height=5, width=6, units="in", dpi=300)
}


computeFreqHeatMap(
  Training_Focus_Self_Div3,
  Pre_Ind_Focus_Self_Div3,
  expression(bold(Focus)),
  expression(bold(widehat(Focus))),
  "Est_Training_Focus_Freqs"
)

computeFreqHeatMap(
  Training_Challenge_Self_Div3,
  Pre_Ind_Challenge_Self_Div3,
  expression(bold(Challenge)),
  expression(bold(widehat(Challenge))),
  "Est_Training_Challenge_Freqs"
)

computeFreqHeatMap(
  Training_Focus_Self_Div3,
  Pre_Group_Focus_Self_Div3,
  expression(bold(Focus)),
  expression(bold(widehat(Focus[bold(Group)]))),
  "GroupEst_Training_Focus_Freqs"
)

computeFreqHeatMap(
  Training_Challenge_Self_Div3,
  Pre_Group_Challenge_Self_Div3,
  expression(bold(Challenge)),
  expression(bold(widehat(Challenge[bold(Group)]))),
  "GroupEst_Training_Challenge_Freqs"
)

computeFreqHeatMap(
  Pre_Ind_Focus_Self_Div3,
  Pre_Group_Focus_Self_Div3,
  expression(bold(widehat(Focus))),
  expression(bold(widehat(Focus[bold(Group)]))),
  "Est_GroupEst_Focus_Freqs"
)

computeFreqHeatMap(
  Pre_Ind_Challenge_Self_Div3,
  Pre_Group_Challenge_Self_Div3,
  expression(bold(widehat(Challenge))),
  expression(bold(widehat(Challenge[bold(Group)]))),
  "Est_GroupEst_Challenge_Freqs"
)

computeFreqHeatMap(
  Pre_Ind_Focus_Other_Div3,
  Pre_Group_Focus_Self_Div3,
  expression(bold(widehat(Focus[bold(Other)]))),
  expression(bold(widehat(Focus[bold(Group)]))),
  "EstOther_GroupEst_Focus_Freqs"
)

computeFreqHeatMap(
  Pre_Ind_Challenge_Other_Div3,
  Pre_Group_Challenge_Self_Div3,
  expression(bold(widehat(Challenge[bold(Other)]))),
  expression(bold(widehat(Challenge[bold(Group)]))),
  "EstOther_GroupEst_Challenge_Freqs"
)

#-------------------------------------


computeBoxPlot(
  Training_Profile_Self,
  IMI_Interest_Enjoyment_Self,
  No_SigLab,
  expression(bold(Preference)),
  expression(bold(Interest/Enjoyment)),
  "Training_Profile_Self_IE",
  hasAngledXAxis = TRUE,
  hasUpOrDown = TRUE,
  hasModifiedLims = TRUE,
  yLimInf = 1,
  yLimSup = 7,
  yBy=2
)

computeBoxPlot(
  Training_Profile_Self,
  IMI_Perceived_Competence_Self,
  Training_Profile_Self_PC_SigLab,
  expression(bold(Preference)),
  expression(bold(PerceivedCompetence)),
  "Training_Profile_Self_PC",
  hasAngledXAxis = TRUE,
  hasUpOrDown = TRUE,
  hasModifiedLims = TRUE,
  yLimInf = 1,
  yLimSup = 7,
  yBy=2
)

computeBoxPlot(
  Training_Profile_Self,
  Survival_Score_Self,
  Training_Profile_Self_SurvivalScore_SigLab,
  expression(bold(Preference)),
  expression(bold("SurvivalScore")),
  "Training_Profile_Self_SurvivalScore",
  hasAngledXAxis = TRUE,
  hasUpOrDown = TRUE,
  charToAddInLegend = 'K',
  hasModifiedLims = TRUE,
  yLimInf = 0,
  yLimSup = 40000,
  yBy=20000
)




# computeBoxPlot(
#   Training_Profile_Other,
#   IMI_Interest_Enjoyment_Self,
#   No_SigLab,
#   expression(bold(Preference)[bold(Other)]),
#   expression(bold(Interest/Enjoyment)),
#   "Training_Profile_Other_IE",
#   hasAngledXAxis = TRUE,
#   hasModifiedLims = TRUE,
#   yLimInf = 1,
#   yLimSup = 7,
#   yBy=2
# )
# 
# computeBoxPlot(
#   Training_Profile_Other,
#   IMI_Perceived_Competence_Self,
#   No_SigLab,
#   expression(bold(Preference)[bold(Other)]),
#   expression(bold(PerceivedCompetence)),
#   "Training_Profile_Other_PC",
#   hasAngledXAxis = TRUE,
#   hasModifiedLims = TRUE,
#   yLimInf = 1,
#   yLimSup = 7,
#   yBy=2
# )

computeBoxPlot(
  Training_Profile_Other,
  Survival_Score_Self,  
  Training_Profile_Other_SurvivalScore_SigLab,
  expression(bold(Preference)[bold(Other)]),
  expression(bold("SurvivalScore")),
  "Training_Profile_Other_SurvivalScore",
  hasAngledXAxis = TRUE,
  hasUpOrDown = TRUE,
  charToAddInLegend = 'K',
  hasModifiedLims = TRUE,
  yLimInf = 0,
  yLimSup = 40000,
  yBy=20000
)


computeBoxPlot(
  Int_Training_Profile_Focus,
  Survival_Score_Self,
  Int_Training_Profile_Focus_SurvivalScore_SigLab,
  expression(bold(FocusCombination)),
  expression(bold("SurvivalScore")),
  "Int_Training_Profile_Focus_SurvivalScore",
  hasAngledXAxis = FALSE,
  hasUpOrDown = TRUE,
  charToAddInLegend = 'K',
  hasModifiedLims = TRUE,
  yLimInf = 0,
  yLimSup = 40000,
  yBy=20000
)



computeBoxPlot(
  RelatednessLevel,
  IMI_Perceived_Competence_Self,
  No_SigLab,
  expression(bold(InterpersonalCloseness)),
  expression(bold(PerceivedCompetence)),
  "RelatednessLevel_PC",
  hasModifiedLims = TRUE,
  yLimInf = 1,
  yLimSup = 7,
  yBy=2
)

computeBoxPlot(
  PlayFreqLevel,
  IMI_Interest_Enjoyment_Self,
  No_SigLab,
  expression(bold(VideogameFamiliarity)),
  expression(bold(Interest/Enjoyment)),
  "PlayFreqLevel_IE",
  hasModifiedLims = TRUE,
  yLimInf = 1,
  yLimSup = 7,
  yBy=2
)
computeBoxPlot(
  PlayFreqLevel,
  IMI_Perceived_Competence_Self,
  No_SigLab,
  expression(bold(VideogameFamiliarity)),
  expression(bold(PerceivedCompetence)),
  "PlayFreqLevel_PC",
  hasModifiedLims = TRUE,
  yLimInf = 1,
  yLimSup = 7,
  yBy=2
)
computeBoxPlot(
  PlayFreqLevel,
  Survival_Score_Self,
  No_SigLab,
  expression(bold(VideogameFamiliarity)),
  expression(bold(SurvivalScore)),
  "PlayFreqLevel_SurvivalScore",
  charToAddInLegend = 'K',
  hasModifiedLims = TRUE,
  yLimInf = 0,
  yLimSup = 40000,
  yBy=20000
)

computeBoxPlot(
  GenreLikingLevel,
  IMI_Interest_Enjoyment_Self,
  No_SigLab,
  expression(bold(GameGenreEnjoyment)),
  expression(bold(Interest/Enjoyment)),
  "GenreLikingLevel_IE",
  hasModifiedLims = TRUE,
  yLimInf = 1,
  yLimSup = 7,
  yBy=2
)




