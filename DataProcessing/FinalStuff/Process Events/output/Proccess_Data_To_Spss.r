suppressMessages(library(dplyr))
suppressMessages(library(maditr))
suppressMessages(library(radiant.data))
require(radiant.data)

events_csv = read.csv('Events_processed_final.csv',
            header = TRUE, sep = ",", quote = "\"",dec = ".",
            fill = TRUE, comment.char = "")

df <- subset(events_csv, select = -c(study_ID,
                                    CompOC_BUFF_PLAYER_COMPANION_ENEMY,
                                    CompOC_BUFF_PLAYER_PLAYER_ENEMY,
                                    CompOC_DEATH_COMPANION_ENEMY_COMPANION,
                                    CompOC_DEATH_PLAYER_ENEMY_PLAYER,
                                    CompOC_HIT_COMPANION_COMPANION_ENEMY,
                                    CompOC_HIT_PLAYER_PLAYER_ENEMY,
                                    CompOC_HIT_KILL_COMPANION_COMPANION_ENEMY,
                                    CompOC_HIT_KILL_PLAYER_PLAYER_ENEMY,
                                    CompOC_MISS_COMPANION_COMPANION_ENEMY,
                                    CompOC_MISS_PLAYER_PLAYER_ENEMY,
                                    CompOC_NERF_PLAYER_COMPANION_ENEMY,
                                    CompOC_NERF_PLAYER_PLAYER_ENEMY,
                                    CompOC_SEC_ATTACK_COMPANION_COMPANION_ENEMY,
                                    CompOC_SEC_ATTACK_PLAYER_PLAYER_ENEMY,
                                    CompOF_BUFF_PLAYER_COMPANION_ENEMY,
                                    CompOF_BUFF_PLAYER_PLAYER_ENEMY,
                                    CompOF_DEATH_COMPANION_ENEMY_COMPANION,
                                    CompOF_DEATH_PLAYER_ENEMY_PLAYER,
                                    CompOF_HIT_COMPANION_COMPANION_ENEMY,
                                    CompOF_HIT_PLAYER_PLAYER_ENEMY,
                                    CompOF_HIT_KILL_COMPANION_COMPANION_ENEMY,
                                    CompOF_HIT_KILL_PLAYER_PLAYER_ENEMY,
                                    CompOF_MISS_COMPANION_COMPANION_ENEMY,
                                    CompOF_MISS_PLAYER_PLAYER_ENEMY,
                                    CompOF_NERF_PLAYER_COMPANION_ENEMY,
                                    CompOF_NERF_PLAYER_PLAYER_ENEMY,
                                    CompOF_SEC_ATTACK_COMPANION_COMPANION_ENEMY,
                                    CompOF_SEC_ATTACK_PLAYER_PLAYER_ENEMY,
                                    CompSC_BUFF_PLAYER_COMPANION_ENEMY,
                                    CompSC_BUFF_PLAYER_PLAYER_ENEMY,
                                    CompSC_DEATH_COMPANION_ENEMY_COMPANION,
                                    CompSC_DEATH_PLAYER_ENEMY_PLAYER,
                                    CompSC_HIT_COMPANION_COMPANION_ENEMY,
                                    CompSC_HIT_PLAYER_PLAYER_ENEMY,
                                    CompSC_HIT_KILL_COMPANION_COMPANION_ENEMY,
                                    CompSC_HIT_KILL_PLAYER_PLAYER_ENEMY,
                                    CompSC_MISS_COMPANION_COMPANION_ENEMY,
                                    CompSC_MISS_PLAYER_PLAYER_ENEMY,
                                    CompSC_NERF_PLAYER_COMPANION_ENEMY,
                                    CompSC_NERF_PLAYER_PLAYER_ENEMY,
                                    CompSC_SEC_ATTACK_COMPANION_COMPANION_ENEMY,
                                    CompSC_SEC_ATTACK_PLAYER_PLAYER_ENEMY,
                                    CompSF_BUFF_PLAYER_COMPANION_ENEMY,
                                    CompSF_BUFF_PLAYER_PLAYER_ENEMY,
                                    CompSF_DEATH_PLAYER_ENEMY_PLAYER,
                                    CompSF_HIT_COMPANION_COMPANION_ENEMY,
                                    CompSF_HIT_PLAYER_PLAYER_ENEMY,
                                    CompSF_HIT_KILL_COMPANION_COMPANION_ENEMY,
                                    CompSF_HIT_KILL_PLAYER_PLAYER_ENEMY,
                                    CompSF_MISS_COMPANION_COMPANION_ENEMY,
                                    CompSF_MISS_PLAYER_PLAYER_ENEMY,
                                    CompSF_NERF_PLAYER_COMPANION_ENEMY,
                                    CompSF_NERF_PLAYER_PLAYER_ENEMY,
                                    CompSF_SEC_ATTACK_COMPANION_COMPANION_ENEMY,
                                    CompSF_SEC_ATTACK_PLAYER_PLAYER_ENEMY,
                                    Carimbo.de.data.hora,
                                    Please.tell.us.the.companion.you.will.play.now,
                                    Please.tell.us.the.companion.you.will.play.now.1,
                                    Please.tell.us.the.companion.you.will.play.now.2,
                                    Please.tell.us.the.companion.you.will.play.now.3,
                                    Please.tell.us.the.companion.you.will.play.now.4,
                                    observed_pref_BUFF_PLAYER,
                                    observed_pref_NERF_PLAYER,
                                    observed_pref_BUFF_COMPANION,
                                    observed_pref_NERF_COMPANION,
                                    BUFF_PLAYER_ENEMY_PERCEIVED_UTILITY,
                                    NERF_PLAYER_ENEMY_PERCEIVED_UTILITY,
                                    BUFF_COMPANION_ENEMY_PERCEIVED_UTILITY,
                                    NERF_COMPANION_ENEMY_PERCEIVED_UTILITY,
                                    CompSC_PERCEIVED_QUADRANT,
                                    CompSF_PERCEIVED_QUADRANT,
                                    CompOC_PERCEIVED_QUADRANT,
                                    CompOF_PERCEIVED_QUADRANT
                                    ))

df["CompSC_NERF_COMPANION_COMPANION_ENEMY"] <- 0

# df$X.I.see.myself.as.a.[df$X.I.see.myself.as.a. == "Self Challenger"] <- "SC"
# df$X.I.see.myself.as.a.[df$X.I.see.myself.as.a. == "Self Facilitator"] <- "SF"
# df$X.I.see.myself.as.a.[df$X.I.see.myself.as.a. == "Others' Challenger"] <- "OC"
# df$X.I.see.myself.as.a.[df$X.I.see.myself.as.a. == "Others' Facilitator"] <- "OF"

# df$OBSERVED_QUADRANT[df$OBSERVED_QUADRANT == "Self Challenger"] <- "SC"
# df$OBSERVED_QUADRANT[df$OBSERVED_QUADRANT == "Self Facilitator"] <- "SF"
# df$OBSERVED_QUADRANT[df$OBSERVED_QUADRANT == "Others' Challenger"] <- "OC"
# df$OBSERVED_QUADRANT[df$OBSERVED_QUADRANT == "Other's Facilitator"] <- "OF"

df$X.I.see.myself.as.a.[df$X.I.see.myself.as.a. == "Self Challenger"] <- 0
df$X.I.see.myself.as.a.[df$X.I.see.myself.as.a. == "Self Facilitator"] <- 1
df$X.I.see.myself.as.a.[df$X.I.see.myself.as.a. == "Others' Challenger"] <- 2
df$X.I.see.myself.as.a.[df$X.I.see.myself.as.a. == "Others' Facilitator"] <- 3

df$OBSERVED_QUADRANT[df$OBSERVED_QUADRANT == "Self Challenger"] <- 0
df$OBSERVED_QUADRANT[df$OBSERVED_QUADRANT == "Self Facilitator"] <- 1
df$OBSERVED_QUADRANT[df$OBSERVED_QUADRANT == "Others' Challenger"] <- 2
df$OBSERVED_QUADRANT[df$OBSERVED_QUADRANT == "Other's Facilitator"] <- 3

write.csv(df, 'Events_processed_final_filtered.csv', row.names = FALSE)