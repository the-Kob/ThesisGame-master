# Read the CSV file into a data frame
data <- read.csv("Events.csv")

# Split the data frame by "study_ID"
study_id_groups <- split(data, data$study_ID)

# Define a directory where you want to save the CSV files
output_directory <- "output/"

# Iterate through each group and save it to a separate CSV file
for (study_id in names(study_id_groups)) {
  group_data <- study_id_groups[[study_id]]
  output_filename <- paste0(output_directory, "study_", study_id, ".csv")
  write.csv(group_data, output_filename, row.names = FALSE)
}