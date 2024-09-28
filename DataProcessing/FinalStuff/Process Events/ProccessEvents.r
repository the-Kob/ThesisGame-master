# Read the CSV file into a data frame
data <- read.csv("Events.csv")

# Example logical vector "booleans" (replace with your actual vector)
booleans <- duplicated(data)

# Initialize variables to keep track of consecutive TRUE counts
consecutive_true_count <- 0

# Initialize a new empty data frame to store the filtered data
filtered_data <- data.frame()

# Iterate through the rows of the data frame and the "booleans" vector
for (i in 1:nrow(data)) {
  # Check if the current element in "booleans" is TRUE
  if (booleans[i]) {
    consecutive_true_count <- consecutive_true_count + 1
  } else {
    consecutive_true_count <- 0
  }
  
  # If we encounter 3 consecutive TRUE values, skip adding this row to the filtered data
  if (consecutive_true_count < 10) {
    filtered_data <- rbind(filtered_data, data[i, ])
    print(i)
  }
}

# Write the filtered data back to a CSV file if needed
write.csv(filtered_data, "Filtered_Events.csv", row.names = FALSE)