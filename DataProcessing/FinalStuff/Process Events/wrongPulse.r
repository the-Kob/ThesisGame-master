# Read the CSV file into a dataframe
df <- read.csv("Events.csv", header = TRUE)

# Filter rows where companion_Type is 1, event_Type is "BUFF", event_Actuator is "COMPANION", and event_Receiver is "COMPANION"
filtered_rows <- subset(df,
                       companion_Type == "1" &
                       event_Type == "BUFF" &
                       event_Actuator == "COMPANION" &
                       event_Receiver == "COMPANION_ENEMY")

print("Self-Facilitator")
print(nrow(filtered_rows))
print(mean(filtered_rows$time_Seconds))
print(sd(filtered_rows$time_Seconds))


filtered_rows <- subset(df,
                       companion_Type == "2" &
                       event_Type == "NERF" &
                       event_Actuator == "COMPANION" &
                       event_Receiver == "PLAYER_ENEMY")

print("Others-Challenger")
print(nrow(filtered_rows))
print(mean(filtered_rows$time_Seconds))
print(sd(filtered_rows$time_Seconds))


filtered_rows <- subset(df,
                       companion_Type == "3" &
                       event_Type == "BUFF" &
                       event_Actuator == "COMPANION" &
                       event_Receiver == "PLAYER_ENEMY")

print("Others-Facilitator")
print(nrow(filtered_rows))
print(mean(filtered_rows$time_Seconds))
print(sd(filtered_rows$time_Seconds))