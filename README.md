# R Guide

This guide provides instructions for using R on research projects. 

## Style and packages

* For coding style practices, follow the tidyverse style guide.
* Generally, use tidyverse. For big data sets (millions of observations), use data.table
* Never use setwd() or absolute file paths. Instead, use relative file paths with the here() package.
* Use `assertthat::assert_that()` frequently to add programmatic sanity checks in the code
* `tabulator::tab()` works similarly to Stata's tabulate. To install, 
  ```r
  devtools::install_github("skhiggins/tabulator")
  ```
* `tabulator::tabcount()` might also be useful to count the number of unique observations defined by a set of variables.

## Folder structure

Generally, within the folder where we are doing data analysis, we have:
* An .Rproj file for the project. (This can be created in Rstudio, with File > New Project.)
  * Note that if you always open the Project within Rstudio before working (see "Project" in the upper right-hand corner of Rstudio) then the here() package will work for relative filepaths.
* data - only raw data go in this folder
* documentation - documentation about the data goes in this folder
* proc - processed data sets go in this folder
* scripts - code goes in this folder

## Master script
Keep a master script 0_master.R that lists each script in the order they should be run to go from raw data to final results. Under the name of each script should be all the input data sets and output data sets that it uses.

## Randomization

When randomizing assignment in an RCT:
* Seed: Use a seed from https://www.random.org/: put Min 1 and Max 100000000, then click Generate, and copy the result into your script. Towards the top of the script, assign the seed with the line
  ```r
  seed <- ... # from random.org`
  ```
  where ... is replaced with the number that you got from random.org 
* Use the `randomizr` package. Here is [a cheatsheet](https://alexandercoppock.com/papers/randomizr_cheatsheet.pdf) of the different randomization functions.
* Immediately before the line using a randomization function, include `set.seed(seed)`.
* Build a randomization check: create a second variable a second time with a new name, repeating `set.seed(seed)` immediately before creating the second variable. Then check that the randomization is identical using `assert_that(all(df$var1 == df$var2))`.
* It is also good to do a more manual check where you run the full script once, save the resulting data with a different name, then restart R (see instructions below), run it a second time. Then read in both data sets with the random assignment and assert that they are identical.
* Note: if creating two cross-randomized variables, you would not want to repeat set.seed(seed) before creating the second one, otherwise it would use the same assignment as the first.

## Running scripts

Once you complete a script, which you might be running line by line while you work on it, make sure the script works on a fresh R session. To do this from Rstudio:
* Ctrl+Shift+F10 to restart the R session running behind the scenes in Rstudio.
* Ctlr+Shift+Enter to run the whole script

## Replicability 

Pending: test the alternatives (`renv`, dockers, etc.)

