library(baseballr)
library(tidyverse)
library(lubridate)

first_half <- seq(ymd('2022-04-01'),ymd('2022-07-17'),by='day')
sec_half <- seq(ymd('2022-07-23'),ymd('2022-10-05'),by='day')
date_chunks <- c(first_half, sec_half)

data_list <- list()

for (i in 1:length(date_chunks)) {
  try({
    data_chunk <- statcast_search(
    start_date = date_chunks[i], end_date = date_chunks [i], player_type = 'batter') %>% 
    select(
      hit_distance_sc, game_date, description, events, pitch_type, pitch_name, 
      release_speed, stand, p_throws, balls, strikes, outs_when_up, inning, 
      inning_topbot, launch_speed, launch_angle, release_spin_rate, at_bat_number, 
      pitch_number, home_team) %>% 
    filter((!is.na(hit_distance_sc)))
  data_list[[i]] <- data_chunk
  })
}

#unique(full_data$events)

full_data <- data_list %>% 
  reduce(full_join)
write_csv(full_data, 'mlb_hit_dist.csv')