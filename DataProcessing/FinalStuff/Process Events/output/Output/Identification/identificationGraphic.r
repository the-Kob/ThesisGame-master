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
realQuadrant <- c(rep("SC", 4), rep("SF", 4), rep("OC", 4), rep("OF", 4))
Perceived_Quadrant <- rep(c("SC", "SF", "OC", "OF") , 4)
Frequency <- c(41, 12, 3, 6, 10, 34, 11, 7, 4, 11, 41, 6, 7, 5, 7, 43)
data <- data.frame(realQuadrant, Perceived_Quadrant, Frequency)

p <- ggplot(data, aes(fill=Perceived_Quadrant, y=Frequency, x=realQuadrant)) + 
    geom_bar(position="dodge", stat="identity") + xlab(expression(bold("Quadrant"))) + 
    ylab(expression(bold("Frequency"))) + ggtitle(expression(bold("Quadrant Identification"))) + 
    labs(fill = expression(bold("Perceived\nQuadrant"))) + 
    scale_y_continuous(expand = expansion(mult = 0.0), limits = c(0, NA)) +
    theme(plot.title = element_text(hjust = 0.5))

ggsave("identifyGraph.png", width = 5, height = 5, units = "in", dpi = 300)

write.csv(data, 'identification_frequency.csv', row.names = FALSE)