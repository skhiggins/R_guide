# Benchmarking qs Package

Here, we test the speed at which the `qsave()` and `qread()` functions from the `qs` package operate relative to the functions `read_rds()`/ `readRDS()`/ `read.fst()` and `write_rds()`/`saveRDS()`/`write.fst()`. There are some benchmarks on the `qs` package that are available on the `qs` package github repository. However, this is mostly an illustration of the parameterization of the `qs` package functions and how different options change the file size and the speed for a single object. The code for the benchmarking can be found [here](https://github.com/noahforougi/R_guide/blob/master/scripts/benchmark_qs.R). In the following tests, we look at the speed and efficiency of the mentioned packages by looking at the performance of functions across objects of different sizes. 

We first look at the speed of saving objects. We look at the performance of the saving functions relative to the size of the file in a csv form. The graphs below shows that the `qsave()` function operates quicker than `saveRDS()`, but not as fast as `save_rds()` or `write.fst()`  for saving files that range in size from ~2 mb to ~800 mb. We also see that `qread()` operates quicker than both the rds functions, while the `fst` package is still quicker. The x-axes has been converted to log scale for better visualization.  

An important caveat to these benchmarks is that the `fst` package is currently only designed for dataframes, so saving complex (and often, large) objects like regressions can only be done through the rds or qs functions. 


Time to Save     | Time to Read
:-------------------------:|:-------------------------:
![](https://github.com/noahforougi/benchmark_qs/blob/master/results/figures/time_to_save.png) |  ![](https://github.com/noahforougi/benchmark_qs/blob/master/results/figures/time_to_read.png)


The other part of the story is looking at the size of the saved .rds / .qs / .fst object. In these results, we see that `qsave()` outperforms every other function in terms of minimizing the size of the saved object. While the `write_rds()` and `read_rds()` are comparable to the `qs` versions in terms of speed, the `qsave()` outperforms alternative functions for compressing the objects. 

<p align="center">
  <img width="500" height="500" src="https://github.com/noahforougi/benchmark_qs/blob/master/results/figures/size_object_saved.png">
</p>
