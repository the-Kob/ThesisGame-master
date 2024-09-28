suppressMessages(library(dplyr))
suppressMessages(library(maditr))
suppressMessages(library(radiant.data))
require(radiant.data)

events_csv = read.csv('Events_processed.csv',
            header = TRUE, sep = ",", quote = "\"",dec = ".",
            fill = TRUE, comment.char = "")


#print(colnames(events_csv))

events_csv$observed_pref_BUFF_PLAYER <- (events_csv$CompSF_BUFF_PLAYER_PLAYER_ENEMY +
                                        events_csv$CompOF_BUFF_PLAYER_PLAYER_ENEMY+
                                        events_csv$CompSC_BUFF_PLAYER_PLAYER_ENEMY +
                                        events_csv$CompOC_BUFF_PLAYER_PLAYER_ENEMY) / 4

events_csv$observed_pref_NERF_PLAYER <- (events_csv$CompSF_NERF_PLAYER_PLAYER_ENEMY +
                                        events_csv$CompOF_NERF_PLAYER_PLAYER_ENEMY+
                                        events_csv$CompSC_NERF_PLAYER_PLAYER_ENEMY +
                                        events_csv$CompOC_NERF_PLAYER_PLAYER_ENEMY) / 4

events_csv$observed_pref_BUFF_COMPANION <- (events_csv$CompSF_BUFF_PLAYER_COMPANION_ENEMY +
                                        events_csv$CompOF_BUFF_PLAYER_COMPANION_ENEMY+
                                        events_csv$CompSC_BUFF_PLAYER_COMPANION_ENEMY +
                                        events_csv$CompOC_BUFF_PLAYER_COMPANION_ENEMY) / 4

events_csv$observed_pref_NERF_COMPANION <- (events_csv$CompSF_NERF_PLAYER_COMPANION_ENEMY +
                                        events_csv$CompOF_NERF_PLAYER_COMPANION_ENEMY+
                                        events_csv$CompSC_NERF_PLAYER_COMPANION_ENEMY +
                                        events_csv$CompOC_NERF_PLAYER_COMPANION_ENEMY) / 4

events_csv$observed_pref <- which.pmax(events_csv$observed_pref_BUFF_PLAYER, events_csv$observed_pref_NERF_PLAYER, events_csv$observed_pref_BUFF_COMPANION, events_csv$observed_pref_NERF_COMPANION)

events_csv$observed_pref[events_csv$observed_pref == 1] <- "Self Challenger"
events_csv$observed_pref[events_csv$observed_pref == 2] <- "Self Facilitator"
events_csv$observed_pref[events_csv$observed_pref == 3] <- "Others' Challenger"
events_csv$observed_pref[events_csv$observed_pref == 4] <- "Other's Facilitator"

events_csv <- mutate(events_csv, GEQ_SCORE_SC_PSYCHOLOGICAL_INVOLVEMENT_EMPATHY = rowMeans(select(events_csv,
                                                c("X.I.empathized.with.the.other.s..",
                                                "X.I.felt.connected.to.the.other.",
                                                "X.I.found.it.enjoyable.to.be.with.the.other.",
                                                "X..When.I.was.happy..the.other.was.happy.",
                                                "X..When.the.other.was.happy..I.was.happy.",
                                                "X.I.admired.the.other.")), na.rm = TRUE))

events_csv <- mutate(events_csv, GEQ_SCORE_SC_PSYCHOLOGICAL_INVOLVEMENT_NEGATIVE_FEELINGS = rowMeans(select(events_csv,
                                                c("X.I.felt.jealous.about.the.other.",
                                                "X.I.influenced.the.mood.of.the.other.",
                                                "X.I.was.influenced.by.the.other.moods.",
                                                "X.I.felt.revengeful.",
                                                "X.I.felt.schadenfreude..malicious.delight..")), na.rm = TRUE))

events_csv <- mutate(events_csv, GEQ_SCORE_SC_PSYCHOLOGICAL_BEHAVIOURAL_INVOLVEMENT = rowMeans(select(events_csv,
                                                c("X.My.actions.depended.on.the.other.actions.",
                                                "X.The.other.s.actions.were.dependent.on.my.actions.",
                                                "X.The.other.paid.close.attention.to.me.",
                                                "X.I.paid.close.attention.to.the.other.",
                                                "X.What.the.other.did.affected.what.I.did.",
                                                "X.What.I.did.affected.what.the.other.did.")), na.rm = TRUE))

events_csv <- mutate(events_csv, GEQ_SCORE_SF_PSYCHOLOGICAL_INVOLVEMENT_EMPATHY = rowMeans(select(events_csv,
                                                c("X.I.empathized.with.the.other.s...1",
                                                "X.I.felt.connected.to.the.other..1",
                                                "X.I.found.it.enjoyable.to.be.with.the.other..1",
                                                "X..When.I.was.happy..the.other.was.happy..1",
                                                "X..When.the.other.was.happy..I.was.happy..1",
                                                "X.I.admired.the.other..1")), na.rm = TRUE))

events_csv <- mutate(events_csv, GEQ_SCORE_SF_PSYCHOLOGICAL_INVOLVEMENT_NEGATIVE_FEELINGS = rowMeans(select(events_csv,
                                                c("X.I.felt.jealous.about.the.other..1",
                                                "X.I.influenced.the.mood.of.the.other..1",
                                                "X.I.was.influenced.by.the.other.moods..1",
                                                "X.I.felt.revengeful..1",
                                                "X.I.felt.schadenfreude..malicious.delight...1")), na.rm = TRUE))

events_csv <- mutate(events_csv, GEQ_SCORE_SF_PSYCHOLOGICAL_BEHAVIOURAL_INVOLVEMENT = rowMeans(select(events_csv,
                                                c("X.My.actions.depended.on.the.other.actions..1",
                                                "X.The.other.s.actions.were.dependent.on.my.actions..1",
                                                "X.The.other.paid.close.attention.to.me..1",
                                                "X.I.paid.close.attention.to.the.other..1",
                                                "X.What.the.other.did.affected.what.I.did..1",
                                                "X.What.I.did.affected.what.the.other.did..1")), na.rm = TRUE))

events_csv <- mutate(events_csv, GEQ_SCORE_OC_PSYCHOLOGICAL_INVOLVEMENT_EMPATHY = rowMeans(select(events_csv,
                                                c("X.I.empathized.with.the.other.s...2",
                                                "X.I.felt.connected.to.the.other..2",
                                                "X.I.found.it.enjoyable.to.be.with.the.other..2",
                                                "X..When.I.was.happy..the.other.was.happy..2",
                                                "X..When.the.other.was.happy..I.was.happy..2",
                                                "X.I.admired.the.other..2")), na.rm = TRUE))

events_csv <- mutate(events_csv, GEQ_SCORE_OC_PSYCHOLOGICAL_INVOLVEMENT_NEGATIVE_FEELINGS = rowMeans(select(events_csv,
                                                c("X.I.felt.jealous.about.the.other..2",
                                                "X.I.influenced.the.mood.of.the.other..2",
                                                "X.I.was.influenced.by.the.other.moods..2",
                                                "X.I.felt.revengeful..2",
                                                "X.I.felt.schadenfreude..malicious.delight...2")), na.rm = TRUE))

events_csv <- mutate(events_csv, GEQ_SCORE_OC_PSYCHOLOGICAL_BEHAVIOURAL_INVOLVEMENT = rowMeans(select(events_csv,
                                                c("X.My.actions.depended.on.the.other.actions..2",
                                                "X.The.other.s.actions.were.dependent.on.my.actions..2",
                                                "X.The.other.paid.close.attention.to.me..2",
                                                "X.I.paid.close.attention.to.the.other..2",
                                                "X.What.the.other.did.affected.what.I.did..2",
                                                "X.What.I.did.affected.what.the.other.did..2")), na.rm = TRUE))

events_csv <- mutate(events_csv, GEQ_SCORE_OF_PSYCHOLOGICAL_INVOLVEMENT_EMPATHY = rowMeans(select(events_csv,
                                                c("X.I.empathized.with.the.other.s...3",
                                                "X.I.felt.connected.to.the.other..3",
                                                "X.I.found.it.enjoyable.to.be.with.the.other..3",
                                                "X..When.I.was.happy..the.other.was.happy..3",
                                                "X..When.the.other.was.happy..I.was.happy..3",
                                                "X.I.admired.the.other..3")), na.rm = TRUE))

events_csv <- mutate(events_csv, GEQ_SCORE_OF_PSYCHOLOGICAL_INVOLVEMENT_NEGATIVE_FEELINGS = rowMeans(select(events_csv,
                                                c("X.I.felt.jealous.about.the.other..3",
                                                "X.I.influenced.the.mood.of.the.other..3",
                                                "X.I.was.influenced.by.the.other.moods..3",
                                                "X.I.felt.revengeful..3",
                                                "X.I.felt.schadenfreude..malicious.delight...3")), na.rm = TRUE))

events_csv <- mutate(events_csv, GEQ_SCORE_OF_PSYCHOLOGICAL_BEHAVIOURAL_INVOLVEMENT = rowMeans(select(events_csv,
                                                c("X.My.actions.depended.on.the.other.actions..3",
                                                "X.The.other.s.actions.were.dependent.on.my.actions..3",
                                                "X.The.other.paid.close.attention.to.me..3",
                                                "X.I.paid.close.attention.to.the.other..3",
                                                "X.What.the.other.did.affected.what.I.did..3",
                                                "X.What.I.did.affected.what.the.other.did..3")), na.rm = TRUE))

events_csv <- subset(events_csv, select = -c(X.I.empathized.with.the.other.s..,
                                            X.I.felt.connected.to.the.other.,
                                            X.I.found.it.enjoyable.to.be.with.the.other.,
                                            X..When.I.was.happy..the.other.was.happy.,
                                            X..When.the.other.was.happy..I.was.happy.,
                                            X.I.admired.the.other.,
                                            X.I.felt.jealous.about.the.other.,
                                            X.I.influenced.the.mood.of.the.other.,
                                            X.I.was.influenced.by.the.other.moods.,
                                            X.I.felt.revengeful.,
                                            X.I.felt.schadenfreude..malicious.delight..,
                                            X.My.actions.depended.on.the.other.actions.,
                                            X.The.other.s.actions.were.dependent.on.my.actions.,
                                            X.The.other.paid.close.attention.to.me.,
                                            X.I.paid.close.attention.to.the.other.,
                                            X.What.the.other.did.affected.what.I.did.,
                                            X.What.I.did.affected.what.the.other.did.,
                                            X.I.empathized.with.the.other.s...1,
                                            X.I.felt.connected.to.the.other..1,
                                            X.I.found.it.enjoyable.to.be.with.the.other..1,
                                            X..When.I.was.happy..the.other.was.happy..1,
                                            X..When.the.other.was.happy..I.was.happy..1,
                                            X.I.admired.the.other..1,
                                            X.I.felt.jealous.about.the.other..1,
                                            X.I.influenced.the.mood.of.the.other..1,
                                            X.I.was.influenced.by.the.other.moods..1,
                                            X.I.felt.revengeful..1,
                                            X.I.felt.schadenfreude..malicious.delight...1,
                                            X.My.actions.depended.on.the.other.actions..1,
                                            X.The.other.s.actions.were.dependent.on.my.actions..1,
                                            X.The.other.paid.close.attention.to.me..1,
                                            X.I.paid.close.attention.to.the.other..1,
                                            X.What.the.other.did.affected.what.I.did..1,
                                            X.What.I.did.affected.what.the.other.did..1,
                                            X.I.empathized.with.the.other.s...2,
                                            X.I.felt.connected.to.the.other..2,
                                            X.I.found.it.enjoyable.to.be.with.the.other..2,
                                            X..When.I.was.happy..the.other.was.happy..2,
                                            X..When.the.other.was.happy..I.was.happy..2,
                                            X.I.admired.the.other..2,
                                            X.I.felt.jealous.about.the.other..2,
                                            X.I.influenced.the.mood.of.the.other..2,
                                            X.I.was.influenced.by.the.other.moods..2,
                                            X.I.felt.revengeful..2,
                                            X.I.felt.schadenfreude..malicious.delight...2,
                                            X.My.actions.depended.on.the.other.actions..2,
                                            X.The.other.s.actions.were.dependent.on.my.actions..2,
                                            X.The.other.paid.close.attention.to.me..2,
                                            X.I.paid.close.attention.to.the.other..2,
                                            X.What.the.other.did.affected.what.I.did..2,
                                            X.What.I.did.affected.what.the.other.did..2,
                                            X.I.empathized.with.the.other.s...3,
                                            X.I.felt.connected.to.the.other..3,
                                            X.I.found.it.enjoyable.to.be.with.the.other..3,
                                            X..When.I.was.happy..the.other.was.happy..3,
                                            X..When.the.other.was.happy..I.was.happy..3,
                                            X.I.admired.the.other..3,
                                            X.I.felt.jealous.about.the.other..3,
                                            X.I.influenced.the.mood.of.the.other..3,
                                            X.I.was.influenced.by.the.other.moods..3,
                                            X.I.felt.revengeful..3,
                                            X.I.felt.schadenfreude..malicious.delight...3,
                                            X.My.actions.depended.on.the.other.actions..3,
                                            X.The.other.s.actions.were.dependent.on.my.actions..3,
                                            X.The.other.paid.close.attention.to.me..3,
                                            X.I.paid.close.attention.to.the.other..3,
                                            X.What.the.other.did.affected.what.I.did..3,
                                            X.What.I.did.affected.what.the.other.did..3))

events_csv$IMI_SCORE <- (events_csv$X.I.enjoyed.doing.this.activity.very.much.. +
                        events_csv$X.This.activity.was.fun.to.do.. -
                        events_csv$X.I.thought.this.was.a.boring.activity.. -
                        events_csv$X.This.activity.did.not.hold.my.attention.at.all.. +
                        events_csv$X.I.would.describe.this.activity.as.very.interesting.. +
                        events_csv$X.I.thought.this.activity.was.quite.enjoyable.. +
                        events_csv$X..While.I.was.doing.this.activity..I.was.thinking.about.how.much.I.enjoyed.it..
                        ) / 7

events_csv <- subset(events_csv, select = -c(X.I.enjoyed.doing.this.activity.very.much..,
                        X.This.activity.was.fun.to.do..,
                        X.I.thought.this.was.a.boring.activity..,
                        X.This.activity.did.not.hold.my.attention.at.all..,
                        X.I.would.describe.this.activity.as.very.interesting..,
                        X.I.thought.this.activity.was.quite.enjoyable..,
                        X..While.I.was.doing.this.activity..I.was.thinking.about.how.much.I.enjoyed.it..
                        ))

write.csv(events_csv, 'Events_processed_final.csv')