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
    theme(plot.title = element_text(size=labelSize*1.6), legend.text = element_text(size=labelSize), axis.text = element_text(size = labelSize*1.8), 
    axis.title = element_text(size = labelSize*1.8, face = "bold"), legend.title = element_blank(), legend.position = 'bottom') + 
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
      p <- p + scale_y_continuous(expand = expansion(mult = 0.0), labels = scales::label_number(scale_cut = scales::cut_short_scale()), limits = c(yLimInf, yLimSup))#, breaks=seq(yLimInf, yLimSup,by=yBy))
    }else{
      p <- p + scale_y_continuous(expand = expansion(mult = 0.0), labels = scales::label_number(scale_cut = scales::cut_short_scale()), limits = c(0, NA))
    }
    
    if(hasAngledXAxis){
      p <- p + theme(axis.text.x =  element_text(vjust = 0.5, angle = 30))
    }
    
    ggsave(paste("Output/Plots/BoxPlots/", pathName, ".png", sep=''), height=5, width=6, units="in", dpi=300)
}

experimentslogByPlayer[,"No_SigLab"] <- ''


experimentslogByPlayer$X.I.see.myself.as.a.[experimentslogByPlayer$X.I.see.myself.as.a. == 0] <- "SC"
experimentslogByPlayer$X.I.see.myself.as.a.[experimentslogByPlayer$X.I.see.myself.as.a. == 1] <- "SF"
experimentslogByPlayer$X.I.see.myself.as.a.[experimentslogByPlayer$X.I.see.myself.as.a. == 2] <- "OC"
experimentslogByPlayer$X.I.see.myself.as.a.[experimentslogByPlayer$X.I.see.myself.as.a. == 3] <- "OF"

experimentslogByPlayer$X.I.see.myself.as.a. <- as.factor(experimentslogByPlayer$X.I.see.myself.as.a.)

experimentslogByPlayer$OBSERVED_QUADRANT[experimentslogByPlayer$OBSERVED_QUADRANT == 0] <- "SC"
experimentslogByPlayer$OBSERVED_QUADRANT[experimentslogByPlayer$OBSERVED_QUADRANT == 1] <- "SF"
experimentslogByPlayer$OBSERVED_QUADRANT[experimentslogByPlayer$OBSERVED_QUADRANT == 2] <- "OC"
experimentslogByPlayer$OBSERVED_QUADRANT[experimentslogByPlayer$OBSERVED_QUADRANT == 3] <- "OF"

experimentslogByPlayer$OBSERVED_QUADRANT <- as.factor(experimentslogByPlayer$OBSERVED_QUADRANT)

computeBoxPlot(
  X.I.see.myself.as.a.,
  CompSC_EXPERIENCE_RATE,
  No_SigLab,
  expression(bold(widehat(Preference))),
  expression(bold("Exp_Rate_SC")),
  "Pref_Est_Exp_Rate/Pref_Exp_Rate_SC",
  hasAngledXAxis = TRUE,
  hasUpOrDown = TRUE,
  hasModifiedLims = TRUE,
  yLimInf = 0,
  yLimSup = 14
)

# computeBoxPlot(
#   X.I.see.myself.as.a.,
#   CompSF_EXPERIENCE_RATE,
#   No_SigLab,
#   expression(bold(widehat(Preference))),
#   expression(bold("Exp_Rate_SF")),
#   "Pref_Est_Exp_Rate/Pref_Exp_Rate_SF",
#   hasAngledXAxis = TRUE,
#   hasUpOrDown = TRUE,
#   hasModifiedLims = TRUE,
#   yLimInf = 0,
#   yLimSup = 14
# )

# computeBoxPlot(
#   X.I.see.myself.as.a.,
#   CompOC_EXPERIENCE_RATE,
#   No_SigLab,
#   expression(bold(widehat(Preference))),
#   expression(bold("Exp_Rate_OC")),
#   "Pref_Est_Exp_Rate/Pref_Exp_Rate_OC",
#   hasAngledXAxis = TRUE,
#   hasUpOrDown = TRUE,
#   hasModifiedLims = TRUE,
#   yLimInf = 0,
#   yLimSup = 14
# )

# computeBoxPlot(
#   X.I.see.myself.as.a.,
#   CompOF_EXPERIENCE_RATE,
#   No_SigLab,
#   expression(bold(widehat(Preference))),
#   expression(bold("Exp_Rate_OF")),
#   "Pref_Est_Exp_Rate/Pref_Exp_Rate_OF",
#   hasAngledXAxis = TRUE,
#   hasUpOrDown = TRUE,
#   hasModifiedLims = TRUE,
#   yLimInf = 0,
#   yLimSup = 14
# )

# computeBoxPlot(
#   OBSERVED_QUADRANT,
#   CompSC_EXPERIENCE_RATE,
#   No_SigLab,
#   expression(bold(widehat(Preference))),
#   expression(bold("Exp_Rate_SC")),
#   "Pref_Observed_Exp_Rate/Pref_Observed_Exp_Rate_SC",
#   hasAngledXAxis = TRUE,
#   hasUpOrDown = TRUE,
#   hasModifiedLims = TRUE,
#   yLimInf = 0,
#   yLimSup = 14
# )

# computeBoxPlot(
#   OBSERVED_QUADRANT,
#   CompSF_EXPERIENCE_RATE,
#   No_SigLab,
#   expression(bold(widehat(Preference))),
#   expression(bold("Exp_Rate_SF")),
#   "Pref_Observed_Exp_Rate/Pref_Observed_Exp_Rate_SF",
#   hasAngledXAxis = TRUE,
#   hasUpOrDown = TRUE,
#   hasModifiedLims = TRUE,
#   yLimInf = 0,
#   yLimSup = 14
# )

# computeBoxPlot(
#   OBSERVED_QUADRANT,
#   CompOC_EXPERIENCE_RATE,
#   No_SigLab,
#   expression(bold(widehat(Preference))),
#   expression(bold("Exp_Rate_OC")),
#   "Pref_Observed_Exp_Rate/Pref_Observed_Exp_Rate_OC",
#   hasAngledXAxis = TRUE,
#   hasUpOrDown = TRUE,
#   hasModifiedLims = TRUE,
#   yLimInf = 0,
#   yLimSup = 14
# )

# computeBoxPlot(
#   OBSERVED_QUADRANT,
#   CompOF_EXPERIENCE_RATE,
#   No_SigLab,
#   expression(bold(widehat(Preference))),
#   expression(bold("Exp_Rate_OF")),
#   "Pref_Observed_Exp_Rate/Pref_Observed_Exp_Rate_OF",
#   hasAngledXAxis = TRUE,
#   hasUpOrDown = TRUE,
#   hasModifiedLims = TRUE,
#   yLimInf = 0,
#   yLimSup = 14
# )

# #GEQ

# computeBoxPlot(
#   X.I.see.myself.as.a.,
#   GEQ_SCORE_SC_PSYCHOLOGICAL_INVOLVEMENT_EMPATHY,
#   No_SigLab,
#   expression(bold(widehat(Preference))),
#   expression(bold("GEQ_EMPATHY_SC")),
#   "Pref_Est_GEQ_EMPATHY/Pref_Est_GEQ_EMPATHY_SC",
#   hasAngledXAxis = TRUE,
#   hasUpOrDown = TRUE,
#   hasModifiedLims = TRUE,
#   yLimInf = 0,
#   yLimSup = 8
# )

# computeBoxPlot(
#   X.I.see.myself.as.a.,
#   GEQ_SCORE_SF_PSYCHOLOGICAL_INVOLVEMENT_EMPATHY,
#   No_SigLab,
#   expression(bold(widehat(Preference))),
#   expression(bold("GEQ_EMPATHY_SF")),
#   "Pref_Est_GEQ_EMPATHY/Pref_Est_GEQ_EMPATHY_SF",
#   hasAngledXAxis = TRUE,
#   hasUpOrDown = TRUE,
#   hasModifiedLims = TRUE,
#   yLimInf = 0,
#   yLimSup = 8
# )

# computeBoxPlot(
#   X.I.see.myself.as.a.,
#   GEQ_SCORE_OC_PSYCHOLOGICAL_INVOLVEMENT_EMPATHY,
#   No_SigLab,
#   expression(bold(widehat(Preference))),
#   expression(bold("GEQ_EMPATHY_OC")),
#   "Pref_Est_GEQ_EMPATHY/Pref_Est_GEQ_EMPATHY_OC",
#   hasAngledXAxis = TRUE,
#   hasUpOrDown = TRUE,
#   hasModifiedLims = TRUE,
#   yLimInf = 0,
#   yLimSup = 8
# )

# computeBoxPlot(
#   X.I.see.myself.as.a.,
#   GEQ_SCORE_OF_PSYCHOLOGICAL_INVOLVEMENT_EMPATHY,
#   No_SigLab,
#   expression(bold(widehat(Preference))),
#   expression(bold("GEQ_EMPATHY_OF")),
#   "Pref_Est_GEQ_EMPATHY/Pref_Est_GEQ_EMPATHY_OF",
#   hasAngledXAxis = TRUE,
#   hasUpOrDown = TRUE,
#   hasModifiedLims = TRUE,
#   yLimInf = 0,
#   yLimSup = 8
# )

#FAZER RESTO DO BOXPLOT