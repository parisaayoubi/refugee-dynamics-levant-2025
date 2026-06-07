# ==================================================
# Refugee-Producing Countries in the Levant (2025)
#
# Author: Parisa Ayoubi, MPH
#
# Data source:
# UNHCR Refugee Data Finder (2025)
#
# Purpose:
# To visualize refugee populations by country of origin
# across selected Levant countries.
# ==================================================

library(sf)
library(ggplot2)
library(dplyr)
library(rnaturalearth)
library(tibble)

# ---------------------------
# step 1: load world boundaries
# ---------------------------

world <- ne_countries(
  scale = "medium",
  returnclass = "sf"
)

# ---------------------------
# using UNHCR refugee populations
# by country of origin (2025)
# ---------------------------

refugee_origin_data <- data.frame(
  name = c(
    "Jordan",
    "Lebanon",
    "Syria",
    "Palestine"
  ),
  refugees = c(
    5066,
    9319,
    5484575,
    46503
  )
)

# ---------------------------
# step 2: join data
# ---------------------------

origin_map <- world %>%
  left_join(
    refugee_origin_data,
    by = "name"
  )

# ---------------------------
# step 3: keep Levant countries only
# ---------------------------

levant_only <- origin_map %>%
  filter(
    name %in% c(
      "Jordan",
      "Lebanon",
      "Syria",
      "Palestine"
    )
  )

# ---------------------------
# step 4: adjust manual label positions to liking
# ---------------------------

label_positions <- tibble(
  name = c(
    "Jordan",
    "Lebanon",
    "Palestine",
    "Syria"
  ),
  
  lon = c(
    36.2,
    34.8,
    34.3,
    38.7
  ),
  
  lat = c(
    31.6,
    34.1,
    32.0,
    35.0
  ),
  
  label = c(
    "Jordan\n5.1K",
    "Lebanon\n9.3K",
    "Palestine\n46.5K",
    "Syria\n5.5M"
  )
)

# ---------------------------
# step 5: create map
# ---------------------------

refugee_map <- ggplot() +
  
  # regional context (light gray neighboring countries)
  geom_sf(
    data = world %>%
      filter(
        name %in% c(
          "Turkey",
          "Iraq",
          "Saudi Arabia",
          "Egypt",
          "Israel",
          "Cyprus"
        )
      ),
    fill = "grey95",
    color = "grey80",
    linewidth = 0.3
  ) +
  
  # main Levant countries
  geom_sf(
    data = levant_only,
    aes(fill = refugees),
    color = "white",
    linewidth = 1.1
  ) +
  
  # outer border layer for crisp country boundaries
  geom_sf(
    data = levant_only,
    fill = NA,
    color = "grey35",
    linewidth = 0.4
  ) +
  
  # adding labels
  geom_text(
    data = label_positions,
    aes(
      x = lon,
      y = lat,
      label = label
    ),
    size = 3,
    fontface = "bold",
    lineheight = 0.9
  ) +
  
  scale_fill_gradient(
    low = "#e8f1fa",
    high = "#5c80bc",
    trans = "log10"
  ) +
  
  guides(fill = "none") +
  
  coord_sf(
    xlim = c(33.5, 43),
    ylim = c(29, 38),
    expand = FALSE
  ) +
  
  labs(
    title = "Refugee-Producing Countries in the Levant, 2025",
    subtitle = "UNHCR refugee populations by country of origin",
    caption = "Source: UNHCR Refugee Data Finder (2025)"
  ) +
  
  theme_minimal() +
  
  theme(
    plot.title = element_text(
      size = 18,
      face = "bold",
      hjust = 0.5
    ),
    
    plot.subtitle = element_text(
      size = 11,
      hjust = 0.5
    ),
    
    plot.caption = element_text(
      size = 9,
      color = "gray40"
    ),
    
    axis.text = element_blank(),
    axis.title = element_blank(),
    axis.ticks = element_blank(),
    
    panel.grid = element_blank(),
    
    panel.background = element_rect(
      fill = "white",
      color = NA
    )
  )

# display map

refugee_map

# save map!

ggsave(
  "refugee_producing_countries_levant_2025.png",
  refugee_map,
  width = 8,
  height = 6,
  dpi = 300
)
