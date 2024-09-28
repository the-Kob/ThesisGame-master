nums <- c(60)
#Study_IDs with problems -> (2,4,7,9,10,11,15,19,22,24,27,34,35,38,39,41,43,46,47,54,56,57,58,60)

print(nums)

for(i in nums){
    random_int <- sample(1:8, 1)
    dataSplit <- paste0("output/study_", i, ".csv")
    data <- read.csv(dataSplit)

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
            random_int <- sample(1:8, 1)
        }
        
        # If we encounter 3 consecutive TRUE values, skip adding this row to the filtered data
        if (consecutive_true_count < random_int) {
            filtered_data <- rbind(filtered_data, data[i, ])
        }
    }

    # Write the filtered data back to a CSV file if needed
    write.csv(filtered_data, dataSplit, row.names = FALSE)
}