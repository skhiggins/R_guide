# Simple examples of using set_theme() to standardize graph formatting
#  Sean Higgins

# PACKAGES --------------------------------------------------------------------
library(tidyverse)
library(here)

# FUNCTIONS -------------------------------------------------------------------
# Read in set_theme function
source(here("scripts", "programs", "set_theme.R"))

# DATA ------------------------------------------------------------------------
# We will use the mtcars dataframe which was already loaded with tidyverse

# ANALYSIS --------------------------------------------------------------------
# Use the defaults
mtcars %>% ggplot() + 
  geom_point(aes(y = hp, x = wt)) + 
  labs(y = "Horsepower", x = "Weight") +
  set_theme()
ggsave(
  here("results", "figures", "set_theme_defaults.eps"), 
  width = 8, # important to explicitly set these arguments 
  height = 4 # for reproducibility of graphs 
    # (otherwise will depend on size of Rstudio plots pane)
)

# Add x and y axes at 0, decrease plot margins,
#  remove extra space below 0, 
#  add some cushion to the right of the y-axis title and above x-axis title.
mtcars %>% ggplot() + 
  geom_point(aes(y = hp, x = wt)) + 
  labs(y = "Horsepower", x = "Weight") +
  geom_hline(yintercept = 0) + 
  geom_vline(xintercept = 0) +
  scale_y_continuous(expand = expansion(mult = c(0, 0.01))) + # get rid of space below 0
  scale_x_continuous(expand = expansion(mult = c(0, 0.01))) + # and at top/right of plot
    # note that expand = c(0, 0) would remove any space beyond scale but 
    # that would lead the points with highest x or y values to get partially cut off
    # so expand = expansion(mult = c(0, 0.01)) expands top/right by 1%
    # see https://ggplot2.tidyverse.org/reference/expansion.html
  set_theme(
    y_title_margin = "r = 5",
    x_title_margin = "t = 5", 
    plot_margin = unit(c(t = 2, r = 2, b = 2, l = 2), "pt")
  )
ggsave(
  here("results", "figures", "set_theme_with_axes.eps"), 
  width = 8, # important to explicitly set these arguments 
  height = 4 # for reproducibility of graphs 
  # (otherwise will depend on size of Rstudio plots pane)
)

# Histogram
mtcars %>% ggplot() + 
  geom_histogram(aes(x = wt)) + 
  labs(y = "Count", x = "Weight") + 
  scale_y_continuous(expand = expansion(mult = c(0, 0.01))) +
  geom_hline(yintercept = 0) + # add horizontal axis; 
    # no vertical axis since histogram doesn't start at 0
  set_theme()
ggsave(
  here("results", "figures", "set_theme_histogram.eps"), 
  width = 8, # important to explicitly set these arguments 
  height = 4 # for reproducibility of graphs 
  # (otherwise will depend on size of Rstudio plots pane)
)
