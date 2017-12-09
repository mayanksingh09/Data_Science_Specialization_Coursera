library(dplyr)
library(tidyr)
setwd("/Users/mayank/Documents/Coursera/Data Science Specialization/ReproducibleResearch")
storm <- read.csv("./data/storm.csv", stringsAsFactors = F)


storm$PROPDMG_actual <- storm$PROPDMG
storm$CROPDMG_actual <- storm$CROPDMG

storm[storm$PROPDMGEXP == "M", "PROPDMG_actual"] <- storm[storm$PROPDMGEXP == "M", "PROPDMG"]*1000000
storm[storm$CROPDMGEXP == "M", "CROPDMG_actual"] <- storm[storm$CROPDMGEXP == "M", "CROPDMG"]*1000000

storm[storm$PROPDMGEXP == "K", "PROPDMG_actual"] <- storm[storm$PROPDMGEXP == "K", "PROPDMG"]*1000
storm[storm$CROPDMGEXP == "K", "CROPDMG_actual"] <- storm[storm$CROPDMGEXP == "K", "CROPDMG"]*1000

storm[storm$PROPDMGEXP == "B", "PROPDMG_actual"] <- storm[storm$PROPDMGEXP == "B", "PROPDMG"]*1000000000
storm[storm$CROPDMGEXP == "B", "CROPDMG_actual"] <- storm[storm$CROPDMGEXP == "B", "CROPDMG"]*1000000000


storm[storm$PROPDMGEXP == "m", "PROPDMG_actual"] <- storm[storm$PROPDMGEXP == "m", "PROPDMG"]*1000000
storm[storm$CROPDMGEXP == "m", "CROPDMG_actual"] <- storm[storm$CROPDMGEXP == "m", "CROPDMG"]*1000000

storm[storm$PROPDMGEXP == "h", "PROPDMG_actual"] <- storm[storm$PROPDMGEXP == "h", "PROPDMG"]*100
storm[storm$CROPDMGEXP == "h", "CROPDMG_actual"] <- storm[storm$CROPDMGEXP == "h", "CROPDMG"]*100


most_harm <- storm %>%
    group_by(EVTYPE) %>%
    summarise(Total_Fatality = sum(FATALITIES), Total_Injuries = sum(INJURIES)) %>%
    arrange(desc(Total_Fatality), desc(Total_Injuries))

eco_harm <- storm %>%
    group_by(EVTYPE) %>%
    summarise(Total_PROPDMG = sum(PROPDMG_actual), Total_CROPDMG = sum(CROPDMG_actual)) %>%
    mutate(Total_DMG = Total_PROPDMG + Total_CROPDMG) %>%
    arrange(desc(Total_DMG))

paste0(most_harm$EVTYPE[1], "S")
paste0(eco_harm$EVTYPE[1], "S")


### Human Harm
g_harm_1 <- ggplot(aes(x = reorder(EVTYPE, Total_Fatality), y = Total_Fatality), data = most_harm[1:5,]) + geom_bar(stat = "identity")
g_harm_1 <- g_harm_1 + labs(x = "", y = "Total Fatalities", title = "Top-5 Harmful Events (Fatalities)") + theme_minimal() + theme(axis.text.x = element_text(angle = 60, hjust = 1))

g_harm_2 <- ggplot(aes(x = reorder(EVTYPE, Total_Injuries), y = Total_Injuries), data = most_harm[1:5,]) + geom_bar(stat = "identity")
g_harm_2 <- g_harm_2 + labs(x = "", y = "Total Injuries", title = "Top-5 Harmful Events (Injuries)") + theme_minimal() + theme(axis.text.x = element_text(angle = 60, hjust = 1))

grid.arrange(g_harm_1, g_harm_2, ncol = 2)


### Eco Harm
g_ecoharm <- ggplot(aes(x = reorder(EVTYPE, Total_DMG), y = Total_DMG/1000000000), data = eco_harm[1:5,]) + geom_bar(stat = "identity")

g_ecoharm <- g_ecoharm + labs(x = "", y = "Total Damage (Billions)", title = "Top-5 Harmful Events (Economically)") + theme_minimal() + theme(axis.text.x = element_text(angle = 60, hjust = 1))
