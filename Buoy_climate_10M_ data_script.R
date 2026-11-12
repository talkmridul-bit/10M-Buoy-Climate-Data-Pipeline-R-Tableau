library(tidyverse)
library(readr)

data_raw<- read_csv(file.choose())
data_raw

glimpse(data_raw)

final_buoy_10M_data<- data_raw %>% distinct() %>%
  mutate(
    
    wspd = as.numeric(wspd),
    wtmp = as.numeric(wtmp)
    
  ) %>% filter(wspd > 0.00 &
                 wtmp > 0 ) %>%
  group_by(station_id) %>%
  summarise(
    
    Avg_Wind_Speed = mean(wspd),
    Avg_Wind_Temp = mean(wtmp),
    Total_Station = n(),
    .groups = 'drop'
  ) %>% arrange(desc(Total_Station))

final_buoy_10M_data

write.csv(final_buoy_10M_data,'Buoy_Climate_10M_data.csv',
          row.names = FALSE)
getwd()
