# Read the CSV file into a data frame
data <- read.csv("Events.csv")

# Count the number of rows for each unique study_ID
study_id_counts <- table(data$study_ID)

# Display the counts
print(study_id_counts)