# Library
library(ggplot2)

# Dummy data
# focus <- c("Self", "Others")
# challenge <- c("Complicate", "Facilitate")
# data <- expand.grid(X=focus, Y=challenge)
# data$Z <- c("13", "26", "2", "21")
# print(data)


# p <- ggplot(data, aes(data$focus,data$challenge, fill=data$Z)) +
#     geom_tile()


# Dummy data
focus <- c("Self", "Others")
challenge <- c("Complicate", "Facilitate")
data <- expand.grid(X=focus, Y=challenge)
data$Z <- c(13,2,26,21)

print(data)

 
# Heatmap 
p <- ggplot(data, aes(x=X, y=Y, fill= Z)) + 
  geom_tile() +
  scale_fill_gradient(low="white",high="#4d4d4d",guide="none") +
  geom_text(aes(label = Z), size = 15, colour = "black") +
  xlab("Focus") + ylab("Challenge") +
  ggtitle(expression(widehat(bold("Preference")))) +
  theme(plot.title = element_text(size=27, hjust = 0.5), legend.text = element_text(size=27), axis.text = element_text(size = 27), axis.title = element_text(size = 27, face = "bold"), legend.title = element_blank(), legend.position = 'bottom')


ggsave(paste("heatmapEst.png", sep=''), height=5, width=6, units="in", dpi=300)

# Dummy data
focus <- c("Self", "Others")
challenge <- c("Complicate", "Facilitate")
data <- expand.grid(X=focus, Y=challenge)
data$Z <- c(18,3,36,5)

print(data)

 
# Heatmap 
p <- ggplot(data, aes(x=X, y=Y, fill= Z)) + 
  geom_tile() +
  scale_fill_gradient(low="white",high="#4d4d4d",guide="none") +
  geom_text(aes(label = Z), size = 15, colour = "black") +
  xlab("Focus") + ylab("Challenge") +
  ggtitle(expression(bold("Preference"))) +
  theme(plot.title = element_text(size=27, hjust = 0.5), legend.text = element_text(size=27), axis.text = element_text(size = 27), axis.title = element_text(size = 27, face = "bold"), legend.title = element_blank(), legend.position = 'bottom')


ggsave(paste("heatmapObs.png", sep=''), height=5, width=6, units="in", dpi=300)