# R Guide

This guide provides instructions for using R on research projects. Its purpose is to use with collaborators and research assistants to make code consistent, easier to read, transparent, and reproducible.

## Style

For coding style practices, follow the [tidyverse style guide](https://style.tidyverse.org/).
* While you should read the style guide and do your best to follow it, once you save the script you can use `styler::style_file()` to fix its formatting and ensure it adheres to the [tidyverse style guide](https://style.tidyverse.org/).
  * Note: `styler::style_file()` overwrites files (if styling results in a change of the code to be formatted). The documentation strongly suggests to only style files that are under version control or to create a backup copy.
  
## Packages

* Use `tidyverse` and/or `data.table` for wrangling data. 
  * For big data (millions of observations), the efficiency advantages of `data.table` become important. 
  * The efficiency advantages of `data.table` can be important even with smaller data sets for tasks like `rbind`ing, reshaping (h/t Grant McDermott's [benchmarks](https://grantmcdermott.com/2020/07/02/even-more-reshape/)), etc.
* Use `stringr` for manipulating strings.
* Use `lubridate` for working with dates.
* Use `conflicted` to explicitly resolve namespace conflicts.
  * `conflicted::conflict_scout()` displays namespace conflicts
  * `conflicted::conflict_prefer()` declares the package to use in namespace conflicts, and the `conflict_prefer()` calls should be a block of code towards the top of the script, underneath the block of `library()` calls.
* Never use `setwd()` or absolute file paths. Instead, use relative file paths with the `here` package.
  * To avoid conflicts with the deprecated `lubridate::here()`, if using both packages in a script, specify `conflict_prefer("here", "here")`.
* Use `assertthat::assert_that()` frequently to add programmatic sanity checks in the code
* Use pipes like `%>%` from `magrittr`. See [here](https://r4ds.had.co.nz/pipes.html) for more on using pipes. Other useful pipes are the compound assignment pipe `%<>%` (which, [unlike Hadley](https://r4ds.had.co.nz/pipes.html#other-tools-from-magrittr), I like to use) and the `%$%` exposition pipe.
* I wrote a package [`tabulator`](https://github.com/skhiggins/tabulator) for some common data wrangling tasks. To install,  `devtools::install_github("skhiggins/tabulator")`.
  * `tabulator::tab()` efficiently tabulates based on a categorical variable, sorts from most common to least common, and displays the proportion of observations with each value, as well as the cumulative proportion.
  * `tabulator::tabcount()` counts the unique number of categories of a categorical variable or formed by a combination of categorical variables.
  * `tabulator::quantiles()` produces quantiles of a variable. It is a wrapper for base R `quantile()` but is easier to use, especially within `data.table`s or `tibble`s.
* Use `fixest` for fixed effects regressions; it is much faster than `lfe` (and also appears to be faster than the best current Julia or Python implementations of fixed effects regression).

## Folder structure

Generally, within the folder where we are doing data analysis, we have:
* An .Rproj file for the project. (This can be created in Rstudio, with File > New Project.)
  * Note that if you always open the Project within Rstudio before working (see "Project" in the upper right-hand corner of Rstudio) then the `here` package will work for relative filepaths.
* data - only raw data go in this folder
* documentation - documentation about the data goes in this folder
* proc - processed data sets go in this folder
* results - results go in this folder
  * figures - subfolder for figures
  * tables - subfolder for tables
* scripts - code goes in this folder
  * Number scripts in the order in which they should be run
  * programs - a subfolder containing functions called by the analysis scripts (if applicable)

## Master script

Keep a master script 0_master.R that lists each script in the order they should be run to go from raw data to final results. Under the name of each script should be a brief description of the purpose of the script, as well all the input data sets and output data sets that it uses. Ideally, a user could run the master script to run the entire analysis from raw data to final results (although this may be infeasible for some project, e.g. one with multiple confidential data sets that can only be accessed on separate servers).

## Graphing

* Use `ggplot`, and for graphs with color consider colorblind-friendly palettes such as `scale_color_viridis_*()` or `ggthemes::scale_color_colorblind()`.
* I wrote a function [`set_theme.R`](scripts/programs/set_theme.R) to standardize and facilitate graph formatting. It can be added to a `ggplot` object like any other theme would be, e.g.:
  ```r
  library(tidyverse)
 
  # use the defaults
  mtcars %>% ggplot() + 
    geom_point(aes(y = hp, x = wt)) + 
    labs(y = "Horsepower", x = "Weight") +
    set_theme()
  ```
  but it differs from other themes in that you can directly change its default formatting within `set_theme()`. See [`set_theme_reprex.R`](scripts/set_theme_reprex.R) for more examples of its use with changes to its defaults, and look at the function itself to see what the arguments and graph formatting settings that it can change are. (Pull requests welcome to expand it to more use cases.) 
* For reproducible graphs (independent of the size of your Plots pane in RStudio), always specify the `width` and `height` arguments in `ggsave()`.
 * To see what the final graph looks like, open the file that you save since its appearance will differ from what you see in the RStudio Plots pane when you specify the `width` and `height` arguments in `ggsave()`.
* For high resolution, save graphs as .eps or .pdf files. 
  * I've written a Python function [`crop_eps`](https://github.com/skhiggins/PythonTools/blob/master/crop_eps.py) to crop .eps files for the times when you can't get the cropping just right in R.
  * `crop_pdf` coming soon
* For maps, use the `sf` package. This package makes plotting maps easy (with `ggplot2::geom_sf()`), and also makes other tasks like joining geocoordinate polygons and points a breeze.

## Randomization

When randomizing assignment in a randomized control trial (RCT):
* Seed: Use a seed from https://www.random.org/: put Min 1 and Max 100000000, then click Generate, and copy the result into your script. Towards the top of the script, assign the seed with the line
  ```r
  seed <- ... # from random.org
  ```
  where `...` is replaced with the number that you got from [random.org](https://www.random.org/) 
* Use the `randomizr` package. Here is [a cheatsheet](https://alexandercoppock.com/papers/randomizr_cheatsheet.pdf) of the different randomization functions.
* Immediately before the line using a randomization function, include `set.seed(seed)`.
* Build a randomization check: create a second variable a second time with a new name, repeating `set.seed(seed)` immediately before creating the second variable. Then check that the randomization is identical using `assert_that(all(df$var1 == df$var2))`.
* It is also good to do a more manual check where you run the full script once, save the resulting data with a different name, then restart R (see instructions below), run it a second time. Then read in both data sets with the random assignment and assert that they are identical.
* Note: if creating two cross-randomized variables, you would not want to repeat `set.seed(seed)` before creating the second one, otherwise it would use the same assignment as the first.

## Running scripts

Once you complete a script, which you might be running line by line while you work on it, make sure the script works on a fresh R session. To do this from RStudio:
* Ctrl+Shift+F10 to restart the R session running behind the scenes in Rstudio.
* Ctrl+Shift+Enter to run the whole script

To avoid inefficiently saving and restoring the workspace when closing and opening RStudio, go to Tools > Global Options... > General and:
* Uncheck "Restore .RData into workspace at startup"
* For "Save Workspace to .RData on exit", select "Never"
* Click OK

Similarly, when running R scripts from the terminal, specify the `--vanilla` option to avoid ineffecient saving/restoring of the workspace.

## Reproducibility 

Use `renv` (instead of `packrat`) to manage the packages used in a project, avoiding conflicts related to package versioning.
* `renv::init()` will create a "local library" of the packages employed in a project. This library will be stored in a new `renv/` folder in the project's directory.
* `renv::snapshot()` will parse the project's local library and save its package sources (e.g. CRAN or GitHub links to the specific package versions) in an `renv.lock` "lockfile". 
* When using the project in a different machine, `renv::restore()` will use this `renv.lock` file to retrieve all the needed packages, in their appropiate versions. 

## Version control

### GitHub
Instructions coming soon.

### Dropbox
Sometimes RStudio projects don't play nicely with Dropbox syncing because Dropbox is trying to continuously sync while you are editing code. To solve this issue on Windows:
1. Open your .Rproj project in RStudio
1. Run the function [`dropbox_project_sync_off()`](scripts/programs/dropbox_project_sync_off.R) ([details](https://community.rstudio.com/t/dropbox-conflicts-with-rproj-user/54059/2))

## Misc.

Some additional tips:

* Error handling: use `purrr::possibly()` and `purrr::safely()` rather than base R `tryCatch()`
* Progress bars: for intensive `purrr::map*()` tasks you can easily add progress bars with `dplyr::progress_estimated()` ([instructions](https://adisarid.github.io/post/2019-01-24-purrrying-progress-bars/))
