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
* Use `assertthat::assert_that()` frequently to add programmatic sanity checks in the code.
* Use pipes like `%>%` from `magrittr`. See [here](https://r4ds.had.co.nz/pipes.html) for more on using pipes. Other useful pipes are the compound assignment pipe `%<>%` (which, [unlike Hadley](https://r4ds.had.co.nz/pipes.html#other-tools-from-magrittr), I like to use) and the `%$%` exposition pipe.
* I wrote a package [`tabulator`](https://github.com/skhiggins/tabulator) for some common data wrangling tasks. To install: 
  ```r 
  remotes::install_github("skhiggins/tabulator")
  ```
  * `tabulator::tab()` efficiently tabulates based on a categorical variable, sorts from most common to least common, and displays the proportion of observations with each value, as well as the cumulative proportion.
  * `tabulator::tabcount()` counts the unique number of categories of a categorical variable or formed by a combination of categorical variables.
  * `tabulator::quantiles()` produces quantiles of a variable. It is a wrapper for base R `quantile()` but is easier to use, especially within `data.table`s or `tibble`s.
* Use `fixest` for fixed effects regressions; it is much faster than `lfe` (and also appears to be faster than the best current Julia or Python implementations of fixed effects regression).
* `Hmisc::describe()` can be useful to print a "codebook" of the data, i.e. some summary stats about each variable in a data set.
  * This can be used in conjunction with `sink()` to print the codebook to a text file. For example:
  ```r 
  library(tidyverse)
  library(Hmisc)
  library(here)
  
  # Write codebook to text file
  sink(here("results", "mtcars_codebook.txt"))
  mtcars %>% describe() %>% print() # print() needed if running script from command line
  sink() # close the sink
  ```
* Use `modelsummary` for formatting tables. 
  
  
## Folder structure

Generally, within the folder where we are doing data analysis, we have:
* An .Rproj file for the project. (This can be created in RStudio, with File > New Project.)
  * Note that if you always open the Project within RStudio before working (see "Project" in the upper right-hand corner of RStudio) then the `here` package will work for relative filepaths.
* data - only raw data go in this folder
* documentation - documentation about the data goes in this folder
* proc - processed data sets go in this folder
* results - results go in this folder
  * figures - subfolder for figures
  * tables - subfolder for tables
* scripts - code goes in this folder
  * programs - a subfolder containing functions called by the analysis scripts (if applicable)

## Scripts structure

### Separating scripts
Because we often work with large data sets and efficiency is important, I advocate (nearly) always separating the following three actions into different scripts:  

1. Data preparation (cleaning and wrangling)  
2. Analysis (e.g. regressions)
3. Production of figures and tables
    
The analysis and figure/table scripts should not change the data sets at all (no pivoting from wide to long or adding new variables); all changes to the data should be made in the data cleaning scripts. The figure/table scripts should not run the regressions or perform other analysis; that should be done in the analysis scripts. This way, if you need to add a robustness check, you don't necessarily have to rerun all the data cleaning code (unless the robustness check requires defining a new variable). If you need to make a formatting change to a figure, you don't have to rerun all the analysis code (which can take awhile to run on large data sets).

### Naming scripts
* Include a 00_run.R script (described below).
* Number scripts in the order in which they should be run, starting with 01.
* Because a project often uses multiple data sources, I usually include a brief description of the data source being used as the first part of the script name (in the example below, `ex` describes the data source), followed by a description of the action being done (e.g. `dataprep`, `reg`, etc.), with each component of the script name separated by an underscore (`_`).

### 00_run.R script 
Keep a "run" script, 00_run.R that lists each script in the order they should be run to go from raw data to final results. Under the name of each script should be a brief description of the purpose of the script, as well all the input data sets and output data sets that it uses. Ideally, a user could run `00_run.R` to run the entire analysis from raw data to final results (although this may be infeasible for some projects, e.g. one with multiple confidential data sets that can only be accessed on separate servers).
* Also include objects that can be set to 0 or 1 to only run some of the scripts from the 00_run.R script (see the example below).

Below is a brief example of a 00_run.R script. (Note that you might replace scripts 03 and 04 with .Rmd files depending on how you want to present the results.)
  
  ```r
  # Run script for example project
  
  # PACKAGES ------------------------------------------------------------------
  library(here)

  # PRELIMINARIES -------------------------------------------------------------
  # Control which scripts run
  run_01_ex_dataprep <- 1
  run_02_ex_reg      <- 1
  run_03_ex_table    <- 1
  run_04_ex_graph    <- 1
  
  # RUN SCRIPTS ---------------------------------------------------------------
  
  # Read and clean example data
  if (run_01_ex_dataprep) source(here("scripts", "01_ex_dataprep.R"), encoding = "UTF-8")
  # INPUTS
  #  here("data", "example.csv") # raw data from XYZ source
  # OUTPUTS
  #  here("proc", "example.rds") # cleaned 
  
  # Regress Y on X in example data
  if (run_02_ex_reg) source(here("scripts", "02_ex_reg.R"), encoding = "UTF-8")
  # INPUTS
  #  here("proc", "example.rds") # 01_ex_dataprep.R
  # OUTPUTS 
  #  here("proc", "ex_fixest.rds") # fixest object from feols regression
  
  # Create table of regression results
  if (run_03_ex_table) source(here("scripts", "03_ex_table.R"), encoding = "UTF-8")
  # INPUTS 
  #  here("proc", "ex_fixest.rds") # 02_ex_reg.R
  # OUTPUTS
  #  here("results", "tables", "ex_fixest_table.tex") # tex of table for paper
  
  # Create scatterplot of Y and X with local polynomial fit
  if (run_04_ex_graph) source(here("scripts", "04_ex_graph.R"), encoding = "UTF-8")
  # INPUTS
  #  here("proc", "example.rds") # 01_ex_dataprep.R
  # OUTPUTS
  #  here("results", "figures", "ex_scatter.eps") # figure
  ```

## Graphing

* Use `ggplot2`, and for graphs with color consider colorblind-friendly palettes such as `scale_color_viridis_*()` or `ggthemes::scale_color_colorblind()`.
* I wrote a function [`set_theme.R`](scripts/programs/set_theme.R) to standardize and facilitate graph formatting. It can be added to a `ggplot` object like any other theme would be, e.g.:
  ```r
  library(tidyverse)
 
  # Use the defaults
  mtcars %>% ggplot() + 
    geom_point(aes(y = hp, x = wt)) + 
    labs(y = "Horsepower", x = "Weight") +
    set_theme()
  ```
  but it differs from other themes in that you can directly change its default formatting within `set_theme()`. For example:
  ```r
  # Change margins
  mtcars %>% ggplot() + 
    geom_point(aes(y = hp, x = wt)) + 
    labs(y = "Horsepower", x = "Weight") +
    set_theme(
      y_title_margin = "r = 5",
      x_title_margin = "t = 5", 
      plot_margin = unit(c(t = 2, r = 2, b = 2, l = 2), "pt")
    )
  ```  
  See [`set_theme_reprex.R`](scripts/set_theme_reprex.R) for more examples of its use with changes to its defaults, and look at the function itself to see what the arguments and graph formatting settings that it can change are. (Pull requests welcome to expand it to more use cases.) 
* For reproducible graphs (independent of the size of your Plots pane in RStudio), always specify the `width` and `height` arguments in `ggsave()`.
 * To see what the final graph looks like, open the file that you save since its appearance will differ from what you see in the RStudio Plots pane when you specify the `width` and `height` arguments in `ggsave()`.
* For high resolution, save graphs as .eps or .pdf files. 
  * I've written a Python function [`crop_eps`](https://github.com/skhiggins/PythonTools/blob/master/crop_eps.py) to crop (post-process) .eps files when you can't get the cropping just right with `ggplot2`.
  * `crop_pdf` coming soon
* For maps, use the `sf` package. This package makes plotting maps easy (with `ggplot2::geom_sf()`), and also makes other tasks like joining geocoordinate polygons and points a breeze.

## Saving files

* For small data sets, save as .csv with `readr::write_csv()` and read with `readr::read_csv()`. (Note: the `readr` package is part of `tidyverse`.)
    * When reading in a large .csv file from another source, it can be worth using `data.table::fread()` for speed improvements.
    * For smaller .csv files I prefer `readr::read_csv()` due to a number of nice features such as the way it handles columns with dates.
    
* For larger data sets, save as .rds with `saveRDS()` or `readr::write_rds()`, and read with `readRDS()` or `readr::read_rds()`. 
    * `readr::write_rds()` is a wrapper for `saveRDS()` that specifies `compress = FALSE` by default. The trade-off is that compressing (the default in `saveRDS()`) will make the file substantially smaller so it takes up less disk space, but it will take longer to read and write. 
    
* When doing a time-consuming `map*()` or loop, e.g. reading in and manipulating separate data sets for each month, it is a good idea to save intermediate objects as part of the function being called by `map*()` or as part of the loop. That way, if something goes wrong you won't lose all your progress. 

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
* As a second randomization check, create a separate script that runs the randomization script once (using `source()`) but then saves the data set with a different name, then runs it again (with `source()`), then reads in the two differently-named data sets from these two runs of the randomization script and ensures that they are identical.
* Note: if creating two cross-randomized variables, you would not want to repeat `set.seed(seed)` before creating the second one, otherwise it would use the same assignment as the first.

Above I described how data preparation scripts should be separate from analysis scripts. Randomization scripts should also be separate from data preparation scripts, i.e. any data preparation needed as an input to the randomization should be done in one script and the randomization script itself should read in the input data, create a variable with random assignments, and save a data set with the random assignments.

## Running scripts

Once you complete a script, which you might be running line by line while you work on it, make sure the script works on a fresh R session. To do this from RStudio:
* Ctrl+Shift+F10 to restart the R session running behind the scenes in RStudio.
* Ctrl+Shift+Enter to run the whole script

To avoid inefficiently saving and restoring the workspace when closing and opening RStudio, go to Tools > Global Options... > General and:
* Uncheck "Restore .RData into workspace at startup"
* For "Save Workspace to .RData on exit", select "Never"
* Click OK

Similarly, when running R scripts from the command line, specify the `--vanilla` option to avoid ineffecient saving/restoring of the workspace.

When calling `source()` within one script (or the RStudio Console) to run another script, always specify the argument `encoding = "UTF-8"`. This ensures that code with special characters (e.g., letters with accent marks) will run correctly.

## Reproducibility 

Use `renv` (instead of `packrat`) to manage the packages used in a project, avoiding conflicts related to package versioning.
* `renv::init()` will create a "local library" of the packages employed in a project. This library will be stored in a new `renv/` folder in the project's directory.
* `renv::snapshot()` will parse the project's local library and save its package sources (e.g. CRAN or GitHub links to the specific package versions) in an `renv.lock` "lockfile". 
* When using the project in a different machine, `renv::restore()` will use this `renv.lock` file to retrieve all the needed packages, in their appropiate versions. 

## Version control

### GitHub
Github is an important tool to maintain version control and for reproducibility purposes. There are many tutorials online, like Grant Mcdermott's slides [here](https://raw.githack.com/uo-ec607/lectures/master/02-git/02-Git.html#9), and I will share some tips from these notes. I will provide instructions for only the most basic commands here. 

We need to first create a git repository or clone an existing one.  

* To clone an existing github repository, use `git pull repolink` where repolink is the link copied from the repository on Github. 
* To initialize a new repo, use `git init` in the project directory

Once you you have initialized a git repository and you make some local changes, you will want to update the Github repository, so that other collaborators can have access to updated files. To do so, we will use the following process:   

* Check the status: `git status`. I like to use this frequently, in order to see file you've changed and those you still need to add or commit.
* Add files for staging: `git add <filename>`. Use this to add local changes to the staging area. 
* Commit: `git commit`. This command saves your changes to the local repository. It will prompt you to add a commit message, which can be more concisley written as `git commit -m "Helpful message"`
* Push changes to github: assuming there is a Github repository created, use `git push origin master` to push your saved local changes to the Github repo. 

However, there are often times when we encounter merge conflicts. A merge conflict is an event that occurs when Git is unable to automatically resolve differences in code between two commits. For example, if a collaborator edits a piece of code, stages, commits and pushes a change, and you try to push changes for the same piece of code, you will encounter a merge conflict. We need to figure out how fix these conflicts.  

* I like to start with `git status` which shows the conflicted files.
* If you open up the conflicted files with any text editor, you will see a couple of things. 
  * `<<<<<<< HEAD` shows the start of the merge conflict.
  * `=======` shows the break point used for comparison.
  * `>>>>>>> <long string>` shows the end of merge conflict.
* You can now manually edit the code and delete whatever lines of code you don't want and the special chanracters that Git added in the file. After that you can stage, commit and push your files without conflict. 


### Dropbox
Sometimes RStudio projects don't play nicely with Dropbox syncing because Dropbox is trying to continuously sync the .Rproj.user file while you are editing code. This leads to a frequent pop-up error message "The process cannot access the file because it's being used by another process." To solve this issue on Windows:
1. Open your .Rproj project in RStudio
1. Run the function [`dropbox_project_sync_off()`](scripts/programs/dropbox_project_sync_off.R) ([details](https://community.rstudio.com/t/dropbox-conflicts-with-rproj-user/54059/2))

#### Linking Github and Dropbox for a project
Here I will present the best methods for linking a project on both Dropbox and Github, which is inspired, but modified from [this tutorial](https://github.com/kbjarkefur/GitHubDropBox)). The RA (or whomever is setting up the project)  should complete ALL of the following steps. Others need to do only the steps marked with (All). Before going ahead, make sure you have both a Github account, a Dropbox account, and the Dropbox app downloaded on your computer. The main idea of this setup is that our Dropbox will serve as an extra clone where we can share new raw data, but the main version control will be done on Github.

1. First, establish the Dropbox folder for the project. Create a Dropbox folder, share it with all project members, and let's call the project we are working on "SampleProject". In this step, we aren't doing anything with Github.

2. The RA will now create a github repo for the project, name it identically to the Dropbox folder and clone it locally to your computer. 

3. (All) Clone the  github repo locally by going to terminal. I will clone this in my home directory. To do so, I would type
```
cd noahforougi
git clone repolink
``` 
where repolink is the link copied from the repository page on Github.com. It is important that when you clone this repository, you are doing it in a directory that is not associated with Dropbox. 

5. The next step is to clone the repository again, but this time **in the local Dropbox directory**. So, for example, say I have cloned the project in this directory `/Users/noahforougi/SampleProject/`. I will now change the directory to my Dropbox directory and clone the Github repo to the Dropbox. 
```
cd /Dropbox/SampleProject/
git clone repolink
```

6. Now, we want to create a more formal project structure. To do so, we are going to edit the Dropbox directly (we will only be doing this once!). Follow the conventions mentioned earlier in this guide, create the project on Dropbox, but **exclude the proc** folder. The dropbox should look something like this:
- Dropbox/
  - SampleProject/
    - data/
\   - documentation/
    - README.md
    - results/
    - scripts/
    
7. (All) We want the Dropbox project structure (which the RA has created) on our local repo which is synched with Github(in my case, the /Users/noahforougi/ directory). We will only have to do this once, but we are going to manually copy and paste all the folders into our local repo. Additionally, create a proc/ folder locally. This allows us to share **raw** data via Dropbox, but the **processed** data will be generated by actually running the scripts locally. Our project should look like this: 
- noahforougi/
  - SampleProject/
    - data/
    - proc/
    - documentation/
    - README.md
    - results/
    - scripts/
    
8. (All) We want to create a .gitignore file in the local directory. This means when we push our local changes to Github, we are ignoring the data/, proc/ and documentation/ folders. This is crucial because of data confidentiality reasons. There are plenty of tutorials online about how to create a .gitignore file. In the gitignore file please include the following:
 
  /documentation/* <br>
  /data/* <br>
  /proc/*
 
9. Now, go back into the Dropbox folder and repeat this step. We need to create a .gitignore file in the Dropbox as well.

Our project structure is complete. We can now make local edits to the scripts and results and push them to Github. All other project members will be able to receive these changes and update their local proc/ files by running the newly synched scripts. The main interactions should be to push local edits to Github. You should **not** be making edits to the scripts located on the Dropbox. If we want to share new raw data, we will need to copy and paste that locally, but it will not cause issues because of the .gitignore file. 
  
## Misc.

Some additional tips:

* Error handling: use `purrr::possibly()` and `purrr::safely()` rather than base R `tryCatch()`
* Progress bars: for intensive `purrr::map*()` tasks you can easily add progress bars with `dplyr::progress_estimated()` ([instructions](https://adisarid.github.io/post/2019-01-24-purrrying-progress-bars/))
* If you need to log some printed output, a quick and dirty way is `sink()`. 
