# ==========================================================
# Refugee-Hosting Countries in the Levant (2025)
#
# Author: Parisa Ayoubi, MPH
#
# Purpose:
# To visualize refugee populations hosted by Levant countries
# using 2025 UNHCR Refugee Data Finder estimates.
#
# Data source:
# UNHCR Refugee Data Finder (2025)
#
# Notes:
# Comparable refugee-hosting data for the State of Palestine
# were unavailable in the selected UNHCR dataset and were
# therefore excluded from this visualization.
#
# ==========================================================

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
# using UNHCR refugee-hosting
# populations (2025)
# ---------------------------

host_data <- data.frame(
  name = c(
    "Jordan",
    "Lebanon",
    "Syria"
  ),
  refugees_hosted = c(
    537485,
    717976,
    8530
  )
)

# ---------------------------
# step 2: join data
# ---------------------------

host_map <- world %>%
  left_join(
    host_data,
    by = "name"
  )

# ---------------------------
# step 3: keep Levant countries only
# ---------------------------

levant_hosts <- host_map %>%
  filter(
    name %in% c(
      "Jordan",
      "Lebanon",
      "Syria"
    )
  )

# ---------------------------
# step 4: adjust label positions
# ---------------------------

label_positions <- tibble(
  name = c(
    "Jordan",
    "Lebanon",
    "Syria"
  ),
  
  lon = c(
    36.2,
    34.8,
    38.7
  ),
  
  lat = c(
    31.6,
    34.1,
    35.0
  ),
  
  label = c(
    "Jordan\n537K",
    "Lebanon\n718K",
    "Syria\n8.5K"
  )
)

# ---------------------------
# step 5: create map
# ---------------------------

ggplot() +
  
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
          "Palestine",
          "Cyprus"
        )
      ),
    fill = "grey95",
    color = "grey80",
    linewidth = 0.3
  ) +
  
  # main Levant countries
  geom_sf(
    data = levant_hosts,
    aes(fill = refugees_hosted),
    color = "white",
    linewidth = 1.1
  ) +
  
  # outer border layer for crisp country boundaries
  geom_sf(
    data = levant_hosts,
    fill = NA,
    color = "grey35",
    linewidth = 0.4
  ) +
  
  # labels
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
    high = "#5c80bc"
  ) +
  
  guides(fill = "none") +
  
  coord_sf(
    xlim = c(33.5, 43),
    ylim = c(29, 38),
    expand = FALSE
  ) +
  
  labs(
    title = "Refugee-Hosting Countries in the Levant, 2025",
    subtitle = "Refugee populations hosted by Jordan, Lebanon, and Syria",
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

# ---------------------------
# step 6: save map
# ---------------------------

ggsave(
  "refugee_hosting_countries_levant_2025.png",
  width = 8,
  height = 6,
  dpi = 300
)