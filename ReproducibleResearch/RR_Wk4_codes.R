head(storm[,c("EVTYPE", "REMARKS")])
library(dplyr)
library(tidyr)

most_harm <- storm %>%
    group_by(EVTYPE) %>%
    summarise(Total_Fatality = sum(FATALITIES), Total_Injuries = sum(INJURIES)) %>%
    arrange(desc(Total_Fatality), desc(Total_Injuries))


eco_harm <- storm %>%
    group_by(EVTYPE) %>%
    mutate(total_cost = )
    summarise(Total_Fatality = sum(FATALITIES), Total_Injuries = sum(INJURIES)) %>%
    arrange(desc(Total_Fatality), desc(Total_Injuries))

unique(storm$PROPDMGEXP)
