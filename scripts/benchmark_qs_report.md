# Benchmarking qs() Package

Here, we test the speed at which the `qsave()` and `qread()` functions from the `qs` package operate relative to the functions `read_rds()`/`readRDS()` and `write_rds()`/`saveRDS()`. We also compare to the functions `write.fst()` and `read.fst()` from the `fst` package. Note that `fst` is designed specifically for the quick serialization and de-serialization of data frames, and as such, won't be helpful when trying to save, for example, large regression objects. There are some benchmarks on the `qs` package that are available on the `qs` [package github repository](https://github.com/traversc/qs). However, this is mostly an illustration of the parameterization of the `qs` package functions and how different options change the file size and the speed for a single object. In the following tests, we look at the speed and efficiency of the mentioned packages by looking at the performance of functions across objects of different sizes. 

We first look at the speed of saving objects. We look at the performance of the saving functions relative to the size of the file in a csv form. The graph below shows that the `qsave()` function operates much quicker than `saveRDS()` or `save_rds()` for saving files that range in size from ~2 mb to ~800 mb. The x-axis has been converted to log scale for better visualization. However, the `fst()` function appears to be fastest when comparing across all functions. 


The other part of the story is looking at the size of the saved .rds/.qs/.fst object. The following figure plots the file size of the saved .rds/.qs/.fst object relative to the natural log of the file size in a csv format. We notice that the function `qsave()` outperforms all functions in terms of lightness of the file. 


Saving a file              |  Size of saved file
:-------------------------:|:-------------------------:
![](https://raw.githubusercontent.com/noahforougi/R_guide/master/results/figures/time_saved.png?raw=true)  |  ![](https://raw.githubusercontent.com/noahforougi/R_guide/master/results/figures/size_saved.png?raw=true) 


It is important to note that these are all with the default settings of `qsave()`, and an important point of the package is that it is highly parameterized and can be customized to choose the right level of speed and compression, depending on the user needs. Again, this can be seen in the `qs` package github. 

The other thing we might want to look at is the speed of reading the files that we saved. Here we plot the average time in seconds it takes to read a file with each of the packages. `fst` performs the best, among the rds functions and the `qread()` function, with default settings. 

<img src="https://raw.githubusercontent.com/noahforougi/R_guide/master/results/figures/time_read.png?raw=true" width="450">



Overall it seems that the `qs` package comes with the ideal balance for speed and compression, and is highly customizable to allow for more speed or compression, depending on user needs (as is `fst`). Moreover, the `qs` package allows to serialize and deserialize non data frame objects, which is currently all that is allowed in the `fst` package. Note this comment from the creator of the `qs` package, on a [blog post](http://svmiller.com/blog/2020/02/comparing-qs-fst-rds-for-bigger-datasets/) comparing speed of `qs` and `fst` functions:   


> Hi, I wrote the qs package, thanks for your endorsement! For the read benchmark, you'll want to call `rm` on the object read in (as well as the original data frame) followed by `gc()` after every iteration, otherwise strings remain in R's cache and you don't get a realistic read benchmark. Secondly, both packages have tunable compression parameters (trading file size for speed). By default, I opted for more compression at the cost of some speed because I think it represents better overall performance (disk space isn't infinite, and there will be some additional time cost on slower drives if the file is out-of-cache).



