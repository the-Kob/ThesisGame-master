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

experimentslogByPlayer = read.csv('Events_processed_final_filtered.csv',
            header = TRUE, sep = ",", quote = "\"",dec = ".",
            fill = TRUE, comment.char = "")

# print(sc_exprate)

standard_error <- function(x) sd(x) / sqrt(length(x)) 

labelSize <- 10
computeBoxPlot <- function(df, var, metric, sigLab, varName, metricName, pathName, 
charToAddInLegend="", hasAngledXAxis = FALSE, hasUpOrDown = FALSE, 
hasModifiedLims = FALSE, yLimInf = 0, yLimSup= 1, yBy=1){

  upOrDown <- 0
  if(hasUpOrDown){
    upOrDown <- as.integer(df[,deparse(substitute(var))])
    upOrDown <- mod(upOrDown,2)
  }

  metricAsArray <- df[,deparse(substitute(metric))]
  allMeans <- group_by(df, {{var}}) %>% summarize(mean = mean({{metric}}), sd = sd({{metric}}), se = standard_error({{metric}}), count = length({{metric}}))
 
  scaleSpan <- max(metricAsArray) - min(metricAsArray)
  scaleSpanWMargin <- min(min(metricAsArray) + 0.7*scaleSpan,0.8*scaleSpan)

  if(charToAddInLegend=="K"){
    allMeans$mean <- allMeans$mean/1000
    allMeans$sd <- allMeans$sd/1000
  }

  counter <- allMeans$count[1]
  
  p <- ggplot(df, aes(x={{var}}, y={{metric}})) + 
    stat_boxplot(geom = "errorbar", width=0.2, lwd=1) + 
    geom_boxplot(fill="#00a0e4", color="black", width=0.3, lwd=1) +
    theme(plot.title = element_text(size=labelSize*1.6), legend.text = element_text(size=labelSize), axis.text = element_text(size = labelSize*1.8), 
    axis.title = element_text(size = labelSize*1.8, face = "bold"), legend.title = element_blank(), legend.position = 'bottom') + 
    guides(col = guide_legend(ncol = 2)) + 
    xlab(varName) + ylab(substitute(paste(metricName,"  n=", counter))) + 
    geom_text(data = df, aes(x = {{var}}, y = mean({{metric}}), label = No_SigLab), 
      nudge_x = -0.3, 
      nudge_y = 0, 
      size = 8) + 
    geom_text(data = df, aes(x = {{var}}, y = mean({{metric}}) +0.5+0.35*upOrDown*scaleSpan, label = paste('(', format(round(allMeans$mean[{{var}}], 2), nsmall = 1),charToAddInLegend, ' ± ', format(round(allMeans$sd[{{var}}], 2), nsmall = 1),charToAddInLegend,')', sep='')), 
      nudge_x = 0, 
      nudge_y = scaleSpanWMargin, 
      size = 5.2, hjust = 0.5, inherit.aes = TRUE, fontface = "bold") + 
    scale_x_discrete(expand = expansion(add = 0.9))

    if(hasModifiedLims){
      p <- p + scale_y_continuous(expand = expansion(mult = 0.0), labels = scales::label_number(scale_cut = scales::cut_short_scale()), limits = c(yLimInf, yLimSup))#, breaks=seq(yLimInf, yLimSup,by=yBy))
    }else{
      p <- p + scale_y_continuous(expand = expansion(mult = 0.0), labels = scales::label_number(scale_cut = scales::cut_short_scale()), limits = c(0, NA))
    }
    
    if(hasAngledXAxis){
      p <- p + theme(axis.text.x =  element_text(vjust = 0.5, angle = 30))
    }
    
    ggsave(paste("Output/Plots/BoxPlots/", pathName, ".png", sep=''), height=5, width=6, units="in", dpi=300)
}

# SC_EXPRATE

newFrame <- experimentslogByPlayer[experimentslogByPlayer$X.I.see.myself.as.a. == 0,]

newFrame <- newFrame[,c("CompSC_EXPERIENCE_RATE","CompSF_EXPERIENCE_RATE","CompOC_EXPERIENCE_RATE","CompOF_EXPERIENCE_RATE")]

newFrame <- melt(newFrame)

newFrame$variable <- as.character(newFrame$variable)

# print(colnames(sc_exprate))

newFrame$variable[newFrame$variable == "CompSC_EXPERIENCE_RATE"] <- "SC"
newFrame$variable[newFrame$variable == "CompSF_EXPERIENCE_RATE"] <- "SF"
newFrame$variable[newFrame$variable == "CompOC_EXPERIENCE_RATE"] <- "OC"
newFrame$variable[newFrame$variable == "CompOF_EXPERIENCE_RATE"] <- "OF"

newFrame$variable <- as.factor(newFrame$variable)

newFrame[,"No_SigLab"] <- '' #Tudo igual


computeBoxPlot(
    newFrame,
    variable,
    value,
    No_SigLab,
    expression(bold("Experience Rate")),
    bold(widehat(Self-Challenger)),
    "Pref_Est_Exp_Rate/Pref_Exp_Rate_SC",
    hasAngledXAxis = TRUE,
    hasUpOrDown = TRUE,
    hasModifiedLims = TRUE,
    yLimInf = 0,
    yLimSup = 14
)

# SF_EXPRATE

newFrame <- experimentslogByPlayer[experimentslogByPlayer$X.I.see.myself.as.a. == 1,]

newFrame <- newFrame[,c("CompSC_EXPERIENCE_RATE","CompSF_EXPERIENCE_RATE","CompOC_EXPERIENCE_RATE","CompOF_EXPERIENCE_RATE")]

newFrame <- melt(newFrame)

newFrame$variable <- as.character(newFrame$variable)

# print(colnames(sc_exprate))

newFrame$variable[newFrame$variable == "CompSC_EXPERIENCE_RATE"] <- "SC"
newFrame$variable[newFrame$variable == "CompSF_EXPERIENCE_RATE"] <- "SF"
newFrame$variable[newFrame$variable == "CompOC_EXPERIENCE_RATE"] <- "OC"
newFrame$variable[newFrame$variable == "CompOF_EXPERIENCE_RATE"] <- "OF"

newFrame$variable <- as.factor(newFrame$variable)

newFrame[,"No_SigLab"] <- '' # OF diferente de OC

newFrame$No_SigLab[newFrame$variable == "OF"] <- 'a'
newFrame$No_SigLab[newFrame$variable == "OC"] <- 'b'


#print(newFrame$No_SigLab)

computeBoxPlot(
    newFrame,
    variable,
    value,
    newFrame$No_SigLab,
    expression(bold("Experience Rate")),
    bold(widehat(Self-Facilitator)),
    "Pref_Est_Exp_Rate/Pref_Exp_Rate_SF",
    hasAngledXAxis = TRUE,
    hasUpOrDown = TRUE,
    hasModifiedLims = TRUE,
    yLimInf = 0,
    yLimSup = 14
)

# OC_EXPRATE

newFrame <- experimentslogByPlayer[experimentslogByPlayer$X.I.see.myself.as.a. == 2,]

newFrame <- newFrame[,c("CompSC_EXPERIENCE_RATE","CompSF_EXPERIENCE_RATE","CompOC_EXPERIENCE_RATE","CompOF_EXPERIENCE_RATE")]

newFrame <- melt(newFrame)

newFrame$variable <- as.character(newFrame$variable)

# print(colnames(sc_exprate))

newFrame$variable[newFrame$variable == "CompSC_EXPERIENCE_RATE"] <- "SC"
newFrame$variable[newFrame$variable == "CompSF_EXPERIENCE_RATE"] <- "SF"
newFrame$variable[newFrame$variable == "CompOC_EXPERIENCE_RATE"] <- "OC"
newFrame$variable[newFrame$variable == "CompOF_EXPERIENCE_RATE"] <- "OF"

newFrame$variable <- as.factor(newFrame$variable)

newFrame[,"No_SigLab"] <- '' # Tudo igual


computeBoxPlot(
    newFrame,
    variable,
    value,
    No_SigLab,
    expression(bold("Experience Rate")),
    bold(widehat(Others-Challenger)),
    "Pref_Est_Exp_Rate/Pref_Exp_Rate_OC",
    hasAngledXAxis = TRUE,
    hasUpOrDown = TRUE,
    hasModifiedLims = TRUE,
    yLimInf = 0,
    yLimSup = 14
)

# OF_EXPRATE

newFrame <- experimentslogByPlayer[experimentslogByPlayer$X.I.see.myself.as.a. == 3,]

newFrame <- newFrame[,c("CompSC_EXPERIENCE_RATE","CompSF_EXPERIENCE_RATE","CompOC_EXPERIENCE_RATE","CompOF_EXPERIENCE_RATE")]

newFrame <- melt(newFrame)

newFrame$variable <- as.character(newFrame$variable)

# print(colnames(sc_exprate))

newFrame$variable[newFrame$variable == "CompSC_EXPERIENCE_RATE"] <- "SC"
newFrame$variable[newFrame$variable == "CompSF_EXPERIENCE_RATE"] <- "SF"
newFrame$variable[newFrame$variable == "CompOC_EXPERIENCE_RATE"] <- "OC"
newFrame$variable[newFrame$variable == "CompOF_EXPERIENCE_RATE"] <- "OF"

newFrame$variable <- as.factor(newFrame$variable)

newFrame[,"No_SigLab"] <- '' # OF diferente de OC e OF diferente de SF

newFrame$No_SigLab[newFrame$variable == "OF"] <- 'a'
newFrame$No_SigLab[newFrame$variable == "OC"] <- 'b'
newFrame$No_SigLab[newFrame$variable == "SF"] <- 'b'


computeBoxPlot(
    newFrame,
    variable,
    value,
    No_SigLab,
    expression(bold("Experience Rate")),
    bold(widehat(Others-Facilitator)),
    "Pref_Est_Exp_Rate/Pref_Exp_Rate_OF",
    hasAngledXAxis = TRUE,
    hasUpOrDown = TRUE,
    hasModifiedLims = TRUE,
    yLimInf = 0,
    yLimSup = 14
)

# SC_EXPRATE (OBS)

newFrame <- experimentslogByPlayer[experimentslogByPlayer$OBSERVED_QUADRANT == 0,]

newFrame <- newFrame[,c("CompSC_EXPERIENCE_RATE","CompSF_EXPERIENCE_RATE","CompOC_EXPERIENCE_RATE","CompOF_EXPERIENCE_RATE")]

newFrame <- melt(newFrame)

newFrame$variable <- as.character(newFrame$variable)

# print(colnames(sc_exprate))

newFrame$variable[newFrame$variable == "CompSC_EXPERIENCE_RATE"] <- "SC"
newFrame$variable[newFrame$variable == "CompSF_EXPERIENCE_RATE"] <- "SF"
newFrame$variable[newFrame$variable == "CompOC_EXPERIENCE_RATE"] <- "OC"
newFrame$variable[newFrame$variable == "CompOF_EXPERIENCE_RATE"] <- "OF"

newFrame$variable <- as.factor(newFrame$variable)

newFrame[,"No_SigLab"] <- '' # Embora tenha dado significativo, tudo igual pelo Boferoni (SC diferente de OC e SF caso contrário)

newFrame$No_SigLab[newFrame$variable == "SC"] <- 'a'
newFrame$No_SigLab[newFrame$variable == "OC"] <- 'b'
newFrame$No_SigLab[newFrame$variable == "SF"] <- 'b'

computeBoxPlot(
    newFrame,
    variable,
    value,
    No_SigLab,
    expression(bold("Experience Rate")),
    bold(Self-Challenger),
    "Pref_Observed_Exp_Rate/Pref_Observed_Exp_Rate_SC",
    hasAngledXAxis = TRUE,
    hasUpOrDown = TRUE,
    hasModifiedLims = TRUE,
    yLimInf = 0,
    yLimSup = 14
)

# SF_EXPRATE (OBS)

newFrame <- experimentslogByPlayer[experimentslogByPlayer$OBSERVED_QUADRANT == 1,]

newFrame <- newFrame[,c("CompSC_EXPERIENCE_RATE","CompSF_EXPERIENCE_RATE","CompOC_EXPERIENCE_RATE","CompOF_EXPERIENCE_RATE")]

newFrame <- melt(newFrame)

newFrame$variable <- as.character(newFrame$variable)

# print(colnames(sc_exprate))

newFrame$variable[newFrame$variable == "CompSC_EXPERIENCE_RATE"] <- "SC"
newFrame$variable[newFrame$variable == "CompSF_EXPERIENCE_RATE"] <- "SF"
newFrame$variable[newFrame$variable == "CompOC_EXPERIENCE_RATE"] <- "OC"
newFrame$variable[newFrame$variable == "CompOF_EXPERIENCE_RATE"] <- "OF"

newFrame$variable <- as.factor(newFrame$variable)

newFrame[,"No_SigLab"] <- '' # OF diferente de OC e OF diferente de SF

newFrame$No_SigLab[newFrame$variable == "OF"] <- 'a'
newFrame$No_SigLab[newFrame$variable == "OC"] <- 'b'
newFrame$No_SigLab[newFrame$variable == "SF"] <- 'b'


computeBoxPlot(
    newFrame,
    variable,
    value,
    No_SigLab,
    expression(bold("Experience Rate")),
    bold(Self-Facilitator),
    "Pref_Observed_Exp_Rate/Pref_Observed_Exp_Rate_SF",
    hasAngledXAxis = TRUE,
    hasUpOrDown = TRUE,
    hasModifiedLims = TRUE,
    yLimInf = 0,
    yLimSup = 14
)

# OC_EXPRATE (OBS)

newFrame <- experimentslogByPlayer[experimentslogByPlayer$OBSERVED_QUADRANT == 2,]

newFrame <- newFrame[,c("CompSC_EXPERIENCE_RATE","CompSF_EXPERIENCE_RATE","CompOC_EXPERIENCE_RATE","CompOF_EXPERIENCE_RATE")]

newFrame <- melt(newFrame)

newFrame$variable <- as.character(newFrame$variable)

# print(colnames(sc_exprate))

newFrame$variable[newFrame$variable == "CompSC_EXPERIENCE_RATE"] <- "SC"
newFrame$variable[newFrame$variable == "CompSF_EXPERIENCE_RATE"] <- "SF"
newFrame$variable[newFrame$variable == "CompOC_EXPERIENCE_RATE"] <- "OC"
newFrame$variable[newFrame$variable == "CompOF_EXPERIENCE_RATE"] <- "OF"

newFrame$variable <- as.factor(newFrame$variable)

newFrame[,"No_SigLab"] <- '' #Tudo igual


computeBoxPlot(
    newFrame,
    variable,
    value,
    No_SigLab,
    expression(bold("Experience Rate")),
    bold(Others-Challenger),
    "Pref_Observed_Exp_Rate/Pref_Observed_Exp_Rate_OC",
    hasAngledXAxis = TRUE,
    hasUpOrDown = TRUE,
    hasModifiedLims = TRUE,
    yLimInf = 0,
    yLimSup = 14
)

# OF_EXPRATE (OBS)

newFrame <- experimentslogByPlayer[experimentslogByPlayer$OBSERVED_QUADRANT == 3,]

newFrame <- newFrame[,c("CompSC_EXPERIENCE_RATE","CompSF_EXPERIENCE_RATE","CompOC_EXPERIENCE_RATE","CompOF_EXPERIENCE_RATE")]

newFrame <- melt(newFrame)

newFrame$variable <- as.character(newFrame$variable)

# print(colnames(sc_exprate))

newFrame$variable[newFrame$variable == "CompSC_EXPERIENCE_RATE"] <- "SC"
newFrame$variable[newFrame$variable == "CompSF_EXPERIENCE_RATE"] <- "SF"
newFrame$variable[newFrame$variable == "CompOC_EXPERIENCE_RATE"] <- "OC"
newFrame$variable[newFrame$variable == "CompOF_EXPERIENCE_RATE"] <- "OF"

newFrame$variable <- as.factor(newFrame$variable)

newFrame[,"No_SigLab"] <- '' #Tudo igual


computeBoxPlot(
    newFrame,
    variable,
    value,
    No_SigLab,
    expression(bold("Experience Rate")),
    bold(Others-Facilitator),
    "Pref_Observed_Exp_Rate/Pref_Observed_Exp_Rate_OF",
    hasAngledXAxis = TRUE,
    hasUpOrDown = TRUE,
    hasModifiedLims = TRUE,
    yLimInf = 0,
    yLimSup = 14
)

# GEQ SC

newFrame <- experimentslogByPlayer[experimentslogByPlayer$X.I.see.myself.as.a. == 0,]

newFrame <- newFrame[,c("GEQ_SCORE_SC_PSYCHOLOGICAL_INVOLVEMENT_EMPATHY","GEQ_SCORE_SF_PSYCHOLOGICAL_INVOLVEMENT_EMPATHY","GEQ_SCORE_OC_PSYCHOLOGICAL_INVOLVEMENT_EMPATHY","GEQ_SCORE_OF_PSYCHOLOGICAL_INVOLVEMENT_EMPATHY")]

newFrame <- melt(newFrame)

newFrame$variable <- as.character(newFrame$variable)

# print(colnames(sc_exprate))

newFrame$variable[newFrame$variable == "GEQ_SCORE_SC_PSYCHOLOGICAL_INVOLVEMENT_EMPATHY"] <- "SC"
newFrame$variable[newFrame$variable == "GEQ_SCORE_SF_PSYCHOLOGICAL_INVOLVEMENT_EMPATHY"] <- "SF"
newFrame$variable[newFrame$variable == "GEQ_SCORE_OC_PSYCHOLOGICAL_INVOLVEMENT_EMPATHY"] <- "OC"
newFrame$variable[newFrame$variable == "GEQ_SCORE_OF_PSYCHOLOGICAL_INVOLVEMENT_EMPATHY"] <- "OF"

newFrame$variable <- as.factor(newFrame$variable)

newFrame[,"No_SigLab"] <- '' #Embora significativo, pelo bonferoni tudo igual (SC diferente de OC e SF caso contrario)

newFrame$No_SigLab[newFrame$variable == "SC"] <- 'a'
newFrame$No_SigLab[newFrame$variable == "OC"] <- 'b'
newFrame$No_SigLab[newFrame$variable == "SF"] <- 'b'

computeBoxPlot(
    newFrame,
    variable,
    value,
    No_SigLab,
    expression(bold("Empathy")),
    bold(widehat("Self-Challenger")),
    "Pref_Est_GEQ_EMPATHY/Pref_Est_GEQ_EMPATHY_SC",
    hasAngledXAxis = TRUE,
    hasUpOrDown = TRUE,
    hasModifiedLims = TRUE,
    yLimInf = 0,
    yLimSup = 7
)

# GEQ SF

newFrame <- experimentslogByPlayer[experimentslogByPlayer$X.I.see.myself.as.a. == 1,]

newFrame <- newFrame[,c("GEQ_SCORE_SC_PSYCHOLOGICAL_INVOLVEMENT_EMPATHY","GEQ_SCORE_SF_PSYCHOLOGICAL_INVOLVEMENT_EMPATHY","GEQ_SCORE_OC_PSYCHOLOGICAL_INVOLVEMENT_EMPATHY","GEQ_SCORE_OF_PSYCHOLOGICAL_INVOLVEMENT_EMPATHY")]

newFrame <- melt(newFrame)

newFrame$variable <- as.character(newFrame$variable)

# print(colnames(sc_exprate))

newFrame$variable[newFrame$variable == "GEQ_SCORE_SC_PSYCHOLOGICAL_INVOLVEMENT_EMPATHY"] <- "SC"
newFrame$variable[newFrame$variable == "GEQ_SCORE_SF_PSYCHOLOGICAL_INVOLVEMENT_EMPATHY"] <- "SF"
newFrame$variable[newFrame$variable == "GEQ_SCORE_OC_PSYCHOLOGICAL_INVOLVEMENT_EMPATHY"] <- "OC"
newFrame$variable[newFrame$variable == "GEQ_SCORE_OF_PSYCHOLOGICAL_INVOLVEMENT_EMPATHY"] <- "OF"

newFrame$variable <- as.factor(newFrame$variable)

newFrame[,"No_SigLab"] <- '' # OF diferente de OC

newFrame$No_SigLab[newFrame$variable == "OF"] <- 'a'
newFrame$No_SigLab[newFrame$variable == "OC"] <- 'b'

computeBoxPlot(
    newFrame,
    variable,
    value,
    No_SigLab,
    expression(bold("Empathy")),
    bold(widehat("Self-Facilitator")),
    "Pref_Est_GEQ_EMPATHY/Pref_Est_GEQ_EMPATHY_SF",
    hasAngledXAxis = TRUE,
    hasUpOrDown = TRUE,
    hasModifiedLims = TRUE,
    yLimInf = 0,
    yLimSup = 7
)

# GEQ OC

newFrame <- experimentslogByPlayer[experimentslogByPlayer$X.I.see.myself.as.a. == 2,]

newFrame <- newFrame[,c("GEQ_SCORE_SC_PSYCHOLOGICAL_INVOLVEMENT_EMPATHY","GEQ_SCORE_SF_PSYCHOLOGICAL_INVOLVEMENT_EMPATHY","GEQ_SCORE_OC_PSYCHOLOGICAL_INVOLVEMENT_EMPATHY","GEQ_SCORE_OF_PSYCHOLOGICAL_INVOLVEMENT_EMPATHY")]

newFrame <- melt(newFrame)

newFrame$variable <- as.character(newFrame$variable)

# print(colnames(sc_exprate))

newFrame$variable[newFrame$variable == "GEQ_SCORE_SC_PSYCHOLOGICAL_INVOLVEMENT_EMPATHY"] <- "SC"
newFrame$variable[newFrame$variable == "GEQ_SCORE_SF_PSYCHOLOGICAL_INVOLVEMENT_EMPATHY"] <- "SF"
newFrame$variable[newFrame$variable == "GEQ_SCORE_OC_PSYCHOLOGICAL_INVOLVEMENT_EMPATHY"] <- "OC"
newFrame$variable[newFrame$variable == "GEQ_SCORE_OF_PSYCHOLOGICAL_INVOLVEMENT_EMPATHY"] <- "OF"

newFrame$variable <- as.factor(newFrame$variable)

newFrame[,"No_SigLab"] <- '' #Tudo igual

computeBoxPlot(
    newFrame,
    variable,
    value,
    No_SigLab,
    expression(bold("Empathy")),
    bold(widehat("Others-Challenger")),
    "Pref_Est_GEQ_EMPATHY/Pref_Est_GEQ_EMPATHY_OC",
    hasAngledXAxis = TRUE,
    hasUpOrDown = TRUE,
    hasModifiedLims = TRUE,
    yLimInf = 0,
    yLimSup = 7
)

# GEQ OF

newFrame <- experimentslogByPlayer[experimentslogByPlayer$X.I.see.myself.as.a. == 3,]

newFrame <- newFrame[,c("GEQ_SCORE_SC_PSYCHOLOGICAL_INVOLVEMENT_EMPATHY","GEQ_SCORE_SF_PSYCHOLOGICAL_INVOLVEMENT_EMPATHY","GEQ_SCORE_OC_PSYCHOLOGICAL_INVOLVEMENT_EMPATHY","GEQ_SCORE_OF_PSYCHOLOGICAL_INVOLVEMENT_EMPATHY")]

newFrame <- melt(newFrame)

newFrame$variable <- as.character(newFrame$variable)

# print(colnames(sc_exprate))

newFrame$variable[newFrame$variable == "GEQ_SCORE_SC_PSYCHOLOGICAL_INVOLVEMENT_EMPATHY"] <- "SC"
newFrame$variable[newFrame$variable == "GEQ_SCORE_SF_PSYCHOLOGICAL_INVOLVEMENT_EMPATHY"] <- "SF"
newFrame$variable[newFrame$variable == "GEQ_SCORE_OC_PSYCHOLOGICAL_INVOLVEMENT_EMPATHY"] <- "OC"
newFrame$variable[newFrame$variable == "GEQ_SCORE_OF_PSYCHOLOGICAL_INVOLVEMENT_EMPATHY"] <- "OF"

newFrame$variable <- as.factor(newFrame$variable)

newFrame[,"No_SigLab"] <- '' # OF diferente dos outros 3

newFrame$No_SigLab[newFrame$variable == "OF"] <- 'a'
newFrame$No_SigLab[newFrame$variable == "OC"] <- 'b'
newFrame$No_SigLab[newFrame$variable == "SF"] <- 'b'
newFrame$No_SigLab[newFrame$variable == "SC"] <- 'b'

computeBoxPlot(
    newFrame,
    variable,
    value,
    No_SigLab,
    expression(bold("Empathy")),
    bold(widehat("Others-Facilitator")),
    "Pref_Est_GEQ_EMPATHY/Pref_Est_GEQ_EMPATHY_OF",
    hasAngledXAxis = TRUE,
    hasUpOrDown = TRUE,
    hasModifiedLims = TRUE,
    yLimInf = 0,
    yLimSup = 7
)

# GEQ SC (OBS)

newFrame <- experimentslogByPlayer[experimentslogByPlayer$OBSERVED_QUADRANT == 0,]

newFrame <- newFrame[,c("GEQ_SCORE_SC_PSYCHOLOGICAL_INVOLVEMENT_EMPATHY","GEQ_SCORE_SF_PSYCHOLOGICAL_INVOLVEMENT_EMPATHY","GEQ_SCORE_OC_PSYCHOLOGICAL_INVOLVEMENT_EMPATHY","GEQ_SCORE_OF_PSYCHOLOGICAL_INVOLVEMENT_EMPATHY")]

newFrame <- melt(newFrame)

newFrame$variable <- as.character(newFrame$variable)

# print(colnames(sc_exprate))

newFrame$variable[newFrame$variable == "GEQ_SCORE_SC_PSYCHOLOGICAL_INVOLVEMENT_EMPATHY"] <- "SC"
newFrame$variable[newFrame$variable == "GEQ_SCORE_SF_PSYCHOLOGICAL_INVOLVEMENT_EMPATHY"] <- "SF"
newFrame$variable[newFrame$variable == "GEQ_SCORE_OC_PSYCHOLOGICAL_INVOLVEMENT_EMPATHY"] <- "OC"
newFrame$variable[newFrame$variable == "GEQ_SCORE_OF_PSYCHOLOGICAL_INVOLVEMENT_EMPATHY"] <- "OF"

newFrame$variable <- as.factor(newFrame$variable)

newFrame[,"No_SigLab"] <- '' # SC diferente de SF e OC

newFrame$No_SigLab[newFrame$variable == "OC"] <- 'b'
newFrame$No_SigLab[newFrame$variable == "SF"] <- 'b'
newFrame$No_SigLab[newFrame$variable == "SC"] <- 'a'

computeBoxPlot(
    newFrame,
    variable,
    value,
    No_SigLab,
    expression(bold("Empathy")),
    bold("Self-Challenger"),
    "Pref_Observed_Est_GEQ_EMPATHY/Pref_Observed_Est_GEQ_EMPATHY_SC",
    hasAngledXAxis = TRUE,
    hasUpOrDown = TRUE,
    hasModifiedLims = TRUE,
    yLimInf = 0,
    yLimSup = 7
)

# GEQ SF (OBS)

newFrame <- experimentslogByPlayer[experimentslogByPlayer$OBSERVED_QUADRANT == 1,]

newFrame <- newFrame[,c("GEQ_SCORE_SC_PSYCHOLOGICAL_INVOLVEMENT_EMPATHY","GEQ_SCORE_SF_PSYCHOLOGICAL_INVOLVEMENT_EMPATHY","GEQ_SCORE_OC_PSYCHOLOGICAL_INVOLVEMENT_EMPATHY","GEQ_SCORE_OF_PSYCHOLOGICAL_INVOLVEMENT_EMPATHY")]

newFrame <- melt(newFrame)

newFrame$variable <- as.character(newFrame$variable)

# print(colnames(sc_exprate))

newFrame$variable[newFrame$variable == "GEQ_SCORE_SC_PSYCHOLOGICAL_INVOLVEMENT_EMPATHY"] <- "SC"
newFrame$variable[newFrame$variable == "GEQ_SCORE_SF_PSYCHOLOGICAL_INVOLVEMENT_EMPATHY"] <- "SF"
newFrame$variable[newFrame$variable == "GEQ_SCORE_OC_PSYCHOLOGICAL_INVOLVEMENT_EMPATHY"] <- "OC"
newFrame$variable[newFrame$variable == "GEQ_SCORE_OF_PSYCHOLOGICAL_INVOLVEMENT_EMPATHY"] <- "OF"

newFrame$variable <- as.factor(newFrame$variable)

newFrame[,"No_SigLab"] <- '' #OF diferente dos outros 3

newFrame$No_SigLab[newFrame$variable == "OF"] <- 'a'
newFrame$No_SigLab[newFrame$variable == "OC"] <- 'b'
newFrame$No_SigLab[newFrame$variable == "SF"] <- 'b'
newFrame$No_SigLab[newFrame$variable == "SC"] <- 'b'

computeBoxPlot(
    newFrame,
    variable,
    value,
    No_SigLab,
    expression(bold("Empathy")),
    bold("Self-Facilitator"),
    "Pref_Observed_Est_GEQ_EMPATHY/Pref_Observed_Est_GEQ_EMPATHY_SF",
    hasAngledXAxis = TRUE,
    hasUpOrDown = TRUE,
    hasModifiedLims = TRUE,
    yLimInf = 0,
    yLimSup = 7
)

# GEQ OC (OBS)

newFrame <- experimentslogByPlayer[experimentslogByPlayer$OBSERVED_QUADRANT == 2,]

newFrame <- newFrame[,c("GEQ_SCORE_SC_PSYCHOLOGICAL_INVOLVEMENT_EMPATHY","GEQ_SCORE_SF_PSYCHOLOGICAL_INVOLVEMENT_EMPATHY","GEQ_SCORE_OC_PSYCHOLOGICAL_INVOLVEMENT_EMPATHY","GEQ_SCORE_OF_PSYCHOLOGICAL_INVOLVEMENT_EMPATHY")]

newFrame <- melt(newFrame)

newFrame$variable <- as.character(newFrame$variable)

# print(colnames(sc_exprate))

newFrame$variable[newFrame$variable == "GEQ_SCORE_SC_PSYCHOLOGICAL_INVOLVEMENT_EMPATHY"] <- "SC"
newFrame$variable[newFrame$variable == "GEQ_SCORE_SF_PSYCHOLOGICAL_INVOLVEMENT_EMPATHY"] <- "SF"
newFrame$variable[newFrame$variable == "GEQ_SCORE_OC_PSYCHOLOGICAL_INVOLVEMENT_EMPATHY"] <- "OC"
newFrame$variable[newFrame$variable == "GEQ_SCORE_OF_PSYCHOLOGICAL_INVOLVEMENT_EMPATHY"] <- "OF"

newFrame$variable <- as.factor(newFrame$variable)

newFrame[,"No_SigLab"] <- '' #Tudo igual

computeBoxPlot(
    newFrame,
    variable,
    value,
    No_SigLab,
    expression(bold("Empathy")),
    bold("Others-Challenger"),
    "Pref_Observed_Est_GEQ_EMPATHY/Pref_Observed_Est_GEQ_EMPATHY_OC",
    hasAngledXAxis = TRUE,
    hasUpOrDown = TRUE,
    hasModifiedLims = TRUE,
    yLimInf = 0,
    yLimSup = 7
)

# GEQ OF (OBS)

newFrame <- experimentslogByPlayer[experimentslogByPlayer$OBSERVED_QUADRANT == 3,]

newFrame <- newFrame[,c("GEQ_SCORE_SC_PSYCHOLOGICAL_INVOLVEMENT_EMPATHY","GEQ_SCORE_SF_PSYCHOLOGICAL_INVOLVEMENT_EMPATHY","GEQ_SCORE_OC_PSYCHOLOGICAL_INVOLVEMENT_EMPATHY","GEQ_SCORE_OF_PSYCHOLOGICAL_INVOLVEMENT_EMPATHY")]

newFrame <- melt(newFrame)

newFrame$variable <- as.character(newFrame$variable)

# print(colnames(sc_exprate))

newFrame$variable[newFrame$variable == "GEQ_SCORE_SC_PSYCHOLOGICAL_INVOLVEMENT_EMPATHY"] <- "SC"
newFrame$variable[newFrame$variable == "GEQ_SCORE_SF_PSYCHOLOGICAL_INVOLVEMENT_EMPATHY"] <- "SF"
newFrame$variable[newFrame$variable == "GEQ_SCORE_OC_PSYCHOLOGICAL_INVOLVEMENT_EMPATHY"] <- "OC"
newFrame$variable[newFrame$variable == "GEQ_SCORE_OF_PSYCHOLOGICAL_INVOLVEMENT_EMPATHY"] <- "OF"

newFrame$variable <- as.factor(newFrame$variable)

newFrame[,"No_SigLab"] <- '' #Tudo igual

computeBoxPlot(
    newFrame,
    variable,
    value,
    No_SigLab,
    expression(bold("Empathy")),
    bold("Others-Facilitator"),
    "Pref_Observed_Est_GEQ_EMPATHY/Pref_Observed_Est_GEQ_EMPATHY_OF",
    hasAngledXAxis = TRUE,
    hasUpOrDown = TRUE,
    hasModifiedLims = TRUE,
    yLimInf = 0,
    yLimSup = 7
)

# Behavioral Involvment OF (EST)

newFrame <- experimentslogByPlayer[experimentslogByPlayer$X.I.see.myself.as.a. == 1,]

newFrame <- newFrame[,c("GEQ_SCORE_SC_PSYCHOLOGICAL_BEHAVIOURAL_INVOLVEMENT","GEQ_SCORE_SF_PSYCHOLOGICAL_BEHAVIOURAL_INVOLVEMENT","GEQ_SCORE_OC_PSYCHOLOGICAL_BEHAVIOURAL_INVOLVEMENT","GEQ_SCORE_OF_PSYCHOLOGICAL_BEHAVIOURAL_INVOLVEMENT")]

newFrame <- melt(newFrame)

newFrame$variable <- as.character(newFrame$variable)

# print(colnames(sc_exprate))

newFrame$variable[newFrame$variable == "GEQ_SCORE_SC_PSYCHOLOGICAL_BEHAVIOURAL_INVOLVEMENT"] <- "SC"
newFrame$variable[newFrame$variable == "GEQ_SCORE_SF_PSYCHOLOGICAL_BEHAVIOURAL_INVOLVEMENT"] <- "SF"
newFrame$variable[newFrame$variable == "GEQ_SCORE_OC_PSYCHOLOGICAL_BEHAVIOURAL_INVOLVEMENT"] <- "OC"
newFrame$variable[newFrame$variable == "GEQ_SCORE_OF_PSYCHOLOGICAL_BEHAVIOURAL_INVOLVEMENT"] <- "OF"

newFrame$variable <- as.factor(newFrame$variable)

newFrame[,"No_SigLab"] <- '' # OF diferente de SC
newFrame$No_SigLab[newFrame$variable == "OF"] <- 'a'
newFrame$No_SigLab[newFrame$variable == "SC"] <- 'b'

computeBoxPlot(
    newFrame,
    variable,
    value,
    No_SigLab,
    expression(bold("Behavioral Involvement")),
    bold(widehat("Self-Facilitator")),
    "Pref_Est_GEQ_BINVOLVEMENT/Pref_Est_GEQ_BINVOLVEMENT_SF",
    hasAngledXAxis = TRUE,
    hasUpOrDown = TRUE,
    hasModifiedLims = TRUE,
    yLimInf = 0,
    yLimSup = 7
)

# Behavioral Involvment OF (OBS)

newFrame <- experimentslogByPlayer[experimentslogByPlayer$OBSERVED_QUADRANT == 1,]

newFrame <- newFrame[,c("GEQ_SCORE_SC_PSYCHOLOGICAL_BEHAVIOURAL_INVOLVEMENT","GEQ_SCORE_SF_PSYCHOLOGICAL_BEHAVIOURAL_INVOLVEMENT","GEQ_SCORE_OC_PSYCHOLOGICAL_BEHAVIOURAL_INVOLVEMENT","GEQ_SCORE_OF_PSYCHOLOGICAL_BEHAVIOURAL_INVOLVEMENT")]

newFrame <- melt(newFrame)

newFrame$variable <- as.character(newFrame$variable)

# print(colnames(sc_exprate))

newFrame$variable[newFrame$variable == "GEQ_SCORE_SC_PSYCHOLOGICAL_BEHAVIOURAL_INVOLVEMENT"] <- "SC"
newFrame$variable[newFrame$variable == "GEQ_SCORE_SF_PSYCHOLOGICAL_BEHAVIOURAL_INVOLVEMENT"] <- "SF"
newFrame$variable[newFrame$variable == "GEQ_SCORE_OC_PSYCHOLOGICAL_BEHAVIOURAL_INVOLVEMENT"] <- "OC"
newFrame$variable[newFrame$variable == "GEQ_SCORE_OF_PSYCHOLOGICAL_BEHAVIOURAL_INVOLVEMENT"] <- "OF"

newFrame$variable <- as.factor(newFrame$variable)

newFrame[,"No_SigLab"] <- '' # OF diferente de SC
newFrame$No_SigLab[newFrame$variable == "OF"] <- 'a'
newFrame$No_SigLab[newFrame$variable == "SC"] <- 'b'

computeBoxPlot(
    newFrame,
    variable,
    value,
    No_SigLab,
    expression(bold("Behavioral Involvement")),
    bold("Self-Facilitator"),
    "Pref_Observed_Est_GEQ_BINVOLVEMENT/Pref_Observed_Est_GEQ_BINVOLVEMENT_SF",
    hasAngledXAxis = TRUE,
    hasUpOrDown = TRUE,
    hasModifiedLims = TRUE,
    yLimInf = 0,
    yLimSup = 7
)