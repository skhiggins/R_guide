# Set theme for graphs
# Sean Higgins

set_theme <- function(
  theme = theme_classic(),
  size = 14, 
  title_size = size,
  title_hjust = 0.5,
  y_title_size = size,
  x_title_size = size,
  y_title_margin = NULL,
  x_title_margin = NULL,
  y_text_size = size,
  x_text_size = size,
  y_text_color = "black",
  x_text_color = "black",
  y_title_color = "black", 
  x_title_color = "black",
  legend_text_size = size,
  legend_position = "none",
  plot_title_position = NULL,
  plot_margin = theme_classic()$plot.margin,
  axis_title_y_blank = FALSE, # to fully left-align
  aspect_ratio = NULL
) {
	
	# Dependencies
	require(ggplot2)
	require(stringr)

  # Size
  size_ <- str_c("size = ", size) # this argument always included
  
  if (is.na(y_title_size)) {
    y_title <- "element_blank()"
  } else {
    
    # y-title margin
    if (!is.null(y_title_margin)) y_title_margin_ <- str_c("margin = margin(", y_title_margin, ")")
    else y_title_margin_ <- ""
    
    
    # y-title color
    if (!is.null(y_title_color)) y_title_color_ <- str_c("color = '", y_title_color, "'")
    else y_title_color_ <- ""
    
    # create y_title
    y_title <- str_c("element_text(", size_, ",", y_title_margin_, ",", y_title_color_, ")")
    
  }
  if (is.na(x_title_size)) {
    x_title <- "element_blank()"
  }
  else {
    # x-title margin
    if (!is.null(x_title_margin)) x_title_margin_ <- str_c("margin = margin(", x_title_margin, ")")
    else x_title_margin_ <- ""
    
    # x-title color
    if (!is.null(x_title_color)) x_title_color_ <- str_c("color = '", x_title_color, "'")
    else x_title_color_ <- ""
    
    # create x_title
    x_title <- str_c("element_text(", size_, ",", x_title_margin_, ",", x_title_color_, ")")
  }
  
  if (axis_title_y_blank) {
    y_title <- "element_blank()" # overwrite what it was written as above
  }
  
  theme + theme(
    plot.title = element_text(size = title_size, hjust = title_hjust),
    plot.title.position = plot_title_position,
    axis.title.y = eval(parse(text = y_title)),
    axis.title.x = eval(parse(text = x_title)),
    axis.ticks = element_blank(),
    axis.text.y = element_text(size = y_text_size, color = y_text_color),
    axis.text.x = element_text(size = x_text_size, color = x_text_color),
    axis.line = element_blank(), # manual axes
    legend.key = element_rect(fill = "white"),
    legend.text = element_text(size = legend_text_size),
    legend.title = element_text(size = legend_text_size),
    aspect.ratio = aspect_ratio,
    plot.margin = plot_margin,
    legend.position = legend_position
  )
}
