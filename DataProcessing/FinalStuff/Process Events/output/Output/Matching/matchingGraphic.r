suppressMessages(library(ggplot2))
suppressMessages(library(Rmisc))
suppressMessages(library(reshape))
suppressMessages(library(dplyr))
suppressMessages(library(readr))
suppressMessages(library(ggpubr))
suppressMessages(library('ggsci'))
suppressMessages(library(scales))
suppressMessages(library(numbers))

# create a dataset
data <- read.csv('matching_frequency.csv',
            header = TRUE, sep = ",", quote = "\"",dec = ".",
            fill = TRUE, comment.char = "")

p <- ggplot(data, aes(x = deviation, y = Percentage, color = companion, shape = companion)) +
    geom_line() + 
    xlab(expression(bold("Deviation (nº of pulses)"))) + 
    ylab(expression(bold("Matches"))) + 
    ggtitle(expression(bold("Estimated Preference vs. Observed Preference"))) +
    labs(color = expression(bold("Quadrant")), shape = expression(bold("Quadrant"))) + 
    theme(plot.title = element_text(hjust = 0.5)) +
    scale_y_continuous(breaks=seq(0,1,by=0.1), labels = scales::percent) +
    geom_point(aes(colour = companion), size = 2)

ggsave("matchingGraph.png", width = 5, height = 5, units = "in", dpi = 300)