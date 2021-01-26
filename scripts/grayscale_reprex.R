# Illustrate how to convert graphs to grayscale using colorblindr

# Packages 
library(tidyverse)
library(colorblindr)
library(here)

# Color graph
in_color <- mtcars %>% ggplot() +
  geom_point(aes(x = disp, y = wt, color = mpg)) +
  scale_color_viridis_c(direction = -1) +
  theme_classic()

# Black and white graph
in_bw <- in_color %>% edit_colors(desaturate)
in_bw %>% plot() # use grid::grid.draw() for maps

# Save the black and white graph
set_last_plot(in_bw) # needed manually for ggsave here
ggsave(here("graphs", "bw.eps"), width = 3, height = 3)

