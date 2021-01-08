# Setup ----------------------------------------------------------------------
# Load packages and user-written functions
library(tidyverse)
library(qs)
library(microbenchmark)
library(here)
library(fst)
source(file = "https://raw.githubusercontent.com/skhiggins/R_guide/master/scripts/programs/set_theme.R")

# Create data ----------------------------------------------------------------
seed <- 4042148
set.seed(seed)
df1 <- data.frame(a=rnorm(100000), 
                  b=rpois(100000,100),
                  c=sample(starnames$IAU,100000,T),
                  d=sample(state.name,100000,T),
                  stringsAsFactors = F)

df2 <- data.frame(a=rnorm(500000), 
                  b=rpois(500000,100),
                  c=sample(starnames$IAU,500000,T),
                  d=sample(state.name,500000,T),
                  stringsAsFactors = F)

df3 <- data.frame(a=rnorm(1000000), 
                  b=rpois(1000000,100),
                  c=sample(starnames$IAU,1000000,T),
                  d=sample(state.name,1000000,T),
                  stringsAsFactors = F)


df4 <- data.frame(a=rnorm(2000000), 
                  b=rpois(2000000,100),
                  c=sample(starnames$IAU,2000000,T),
                  d=sample(state.name,2000000,T),
                  stringsAsFactors = F)

df5 <- data.frame(a=rnorm(3000000), 
                  b=rpois(3000000,100),
                  c=sample(starnames$IAU,3000000,T),
                  d=sample(state.name,3000000,T),
                  stringsAsFactors = F)

df6 <- data.frame(a=rnorm(4000000), 
                  b=rpois(4000000,100),
                  c=sample(starnames$IAU,4000000,T),
                  d=sample(state.name,4000000,T),
                  stringsAsFactors = F)


df7 <- data.frame(a=rnorm(5e6), 
                  b=rpois(5e6,100),
                  c=sample(starnames$IAU,5e6,T),
                  d=sample(state.name,5e6,T),
                  stringsAsFactors = F)


df8 <- data.frame(a=rnorm(1e7), 
                  b=rpois(1e7,100),
                  c=sample(starnames$IAU,1e7,T),
                  d=sample(state.name,1e7,T),
                  stringsAsFactors = F)


df9 <- data.frame(a=rnorm(2e7), 
                  b=rpois(2e7,100),
                  c=sample(starnames$IAU,2e7,T),
                  d=sample(state.name,2e7,T),
                  stringsAsFactors = F)

# Write the dataframes to benchmark the csv size of the object
write_csv(df1, here("proc", "df1.csv"))
write_csv(df2, here("proc", "df2.csv"))
write_csv(df3, here("proc", "df3.csv"))
write_csv(df4, here("proc", "df4.csv"))
write_csv(df5, here("proc", "df5.csv"))
write_csv(df6, here("proc", "df6.csv"))
write_csv(df7, here("proc", "df7.csv"))
write_csv(df8, here("proc", "df8.csv"))
write_csv(df9, here("proc", "df9.csv"))


# Test speed of writing objects ---------------------------------------------
# First, we want to test the speed of writing objects.
df1_results <- bind_rows(microbenchmark(write_rds(df1, path = here("proc", "df1_write_rds.rds")), times = 10),
                         microbenchmark(saveRDS(  df1, file = here("proc", "df1_saveRDS.rds")),   times = 10),
                         microbenchmark(qsave(    df1, file = here("proc", "df1_qsave.qs")),      times = 10),
                         microbenchmark(write.fst(df1, path = here("proc", "df1_writefst.fst")),  times = 10))

df2_results <- bind_rows(microbenchmark(write_rds(df2, path = here("proc", "df2_write_rds.rds")), times = 10),
                         microbenchmark(saveRDS(  df2, file = here("proc", "df2_saveRDS.rds")),   times = 10),
                         microbenchmark(qsave(    df2, file = here("proc", "df2_qsave.qs")),      times = 10),
                         microbenchmark(write.fst(df2, path = here("proc", "df2_writefst.fst")),  times = 10))

df3_results <- bind_rows(microbenchmark(write_rds(df3, path = here("proc", "df3_write_rds.rds")), times = 10),
                         microbenchmark(saveRDS(  df3, file = here("proc", "df3_saveRDS.rds")),   times = 10),
                         microbenchmark(qsave(    df3, file = here("proc", "df3_qsave.qs")),      times = 10),
                         microbenchmark(write.fst(df3, path = here("proc", "df3_writefst.fst")),  times = 10))

df4_results <- bind_rows(microbenchmark(write_rds(df4, path = here("proc", "df4_write_rds.rds")), times = 10),
                         microbenchmark(saveRDS(  df4, file = here("proc", "df4_saveRDS.rds")),   times = 10),
                         microbenchmark(qsave(    df4, file = here("proc", "df4_qsave.qs")),      times = 10),
                         microbenchmark(write.fst(df4, path = here("proc", "df4_writefst.fst")),  times = 10))

df5_results <- bind_rows(microbenchmark(write_rds(df5, path = here("proc", "df5_write_rds.rds")), times = 5),
                         microbenchmark(saveRDS(  df5, file = here("proc", "df5_saveRDS.rds")),   times = 5),
                         microbenchmark(qsave(    df5, file = here("proc", "df5_qsave.qs")),      times = 5),
                         microbenchmark(write.fst(df5, path = here("proc", "df5_writefst.fst")),  times = 5))

df6_results <- bind_rows(microbenchmark(write_rds(df6, path = here("proc", "df6_write_rds.rds")), times = 2),
                         microbenchmark(saveRDS(  df6, file = here("proc", "df6_saveRDS.rds")),   times = 2),
                         microbenchmark(qsave(    df6, file = here("proc", "df6_qsave.qs")),      times = 2),
                         microbenchmark(write.fst(df6, path = here("proc", "df6_writefst.fst")),  times = 2))

df7_results <- bind_rows(microbenchmark(write_rds(df7, path = here("proc", "df7_write_rds.rds")), times = 2),
                         microbenchmark(saveRDS(  df7, file = here("proc", "df7_saveRDS.rds")),   times = 2),
                         microbenchmark(qsave(    df7, file = here("proc", "df7_qsave.qs")),      times = 2),
                         microbenchmark(write.fst(df7, path = here("proc", "df7_writefst.fst")),  times = 2))

df8_results <- bind_rows(microbenchmark(write_rds(df8, path = here("proc", "df8_write_rds.rds")), times = 2),
                         microbenchmark(saveRDS(  df8, file = here("proc", "df8_saveRDS.rds")),   times = 2),
                         microbenchmark(qsave(    df8, file = here("proc", "df8_qsave.qs")),      times = 2),
                         microbenchmark(write.fst(df8, path = here("proc", "df8_writefst.fst")),  times = 2))

df9_results <- bind_rows(microbenchmark(write_rds(df9, path = here("proc", "df9_write_rds.rds")), times = 2),
                         microbenchmark(saveRDS(  df9, file = here("proc", "df9_saveRDS.rds")),   times = 2),
                         microbenchmark(qsave(    df9, file = here("proc", "df9_qsave.qs")),      times = 2),
                         microbenchmark(write.fst(df9, path = here("proc", "df9_writefst.fst")),  times = 2))

# Save the results
bind_rows(df1_results, df2_results, df3_results, 
          df4_results, df5_results, df6_results, 
          df7_results, df8_results, df9_results) %>%
  summary() %>% 
  data.frame() %>%
  write_csv(., path = here("proc", "save_results.csv"))


# Test speed of reading objects ------------------------------------------------------
df1_read_results <- bind_rows(microbenchmark(read_rds(path = here("proc", "df1_write_rds.rds")),  times = 10),
                              microbenchmark(readRDS(  file = here("proc", "df1_saveRDS.rds")),   times = 10),
                              microbenchmark(qread(    file = here("proc", "df1_qsave.qs")),      times = 10),
                              microbenchmark(read.fst(path = here("proc", "df1_writefst.fst")),   times = 10))

df2_read_results <- bind_rows(microbenchmark(read_rds(path = here("proc", "df2_write_rds.rds")), times = 10),
                              microbenchmark(readRDS( file = here("proc", "df2_saveRDS.rds")),   times = 10),
                              microbenchmark(qread(   file = here("proc", "df2_qsave.qs")),      times = 10),
                              microbenchmark(read.fst(path = here("proc", "df2_writefst.fst")),  times = 10))

df3_read_results <- bind_rows(microbenchmark(read_rds(path = here("proc", "df3_write_rds.rds")), times = 10),
                              microbenchmark(readRDS( file = here("proc", "df3_saveRDS.rds")),   times = 10),
                              microbenchmark(qread(   file = here("proc", "df3_qsave.qs")),      times = 10),
                              microbenchmark(read.fst(path = here("proc", "df3_writefst.fst")),  times = 10))

df4_read_results <- bind_rows(microbenchmark(read_rds(path = here("proc", "df4_write_rds.rds")), times = 10),
                              microbenchmark(readRDS( file = here("proc", "df4_saveRDS.rds")),   times = 10),
                              microbenchmark(qread(   file = here("proc", "df4_qsave.qs")),      times = 10),
                              microbenchmark(read.fst(path = here("proc", "df4_writefst.fst")),  times = 10))

df5_read_results <- bind_rows(microbenchmark(read_rds(path = here("proc", "df5_write_rds.rds")), times = 5),
                              microbenchmark(readRDS( file = here("proc", "df5_saveRDS.rds")),   times = 5),
                              microbenchmark(qread(   file = here("proc", "df5_qsave.qs")),      times = 5),
                              microbenchmark(read.fst(path = here("proc", "df5_writefst.fst")),  times = 5))

df6_read_results <- bind_rows(microbenchmark(read_rds(path = here("proc", "df6_write_rds.rds")), times = 2),
                              microbenchmark(readRDS( file = here("proc", "df6_saveRDS.rds")),   times = 2),
                              microbenchmark(qread(   file = here("proc", "df6_qsave.qs")),      times = 2),
                              microbenchmark(read.fst(path = here("proc", "df6_writefst.fst")),  times = 2))

df7_read_results <- bind_rows(microbenchmark(read_rds(path = here("proc", "df7_write_rds.rds")), times = 2),
                              microbenchmark(readRDS( file = here("proc", "df7_saveRDS.rds")),   times = 2),
                              microbenchmark(qread(   file = here("proc", "df7_qsave.qs")),      times = 2),
                              microbenchmark(read.fst(path = here("proc", "df7_writefst.fst")),  times = 2))

df8_read_results <- bind_rows(microbenchmark(read_rds(path = here("proc", "df8_write_rds.rds")), times = 2),
                              microbenchmark(readRDS( file = here("proc", "df8_saveRDS.rds")),   times = 2),
                              microbenchmark(qread(   file = here("proc", "df8_qsave.qs")),      times = 2),
                              microbenchmark(read.fst(path = here("proc", "df8_writefst.fst")),  times = 2))

df9_read_results <- bind_rows(microbenchmark(read_rds(path = here("proc", "df9_write_rds.rds")), times = 2),
                              microbenchmark(readRDS( file = here("proc", "df9_saveRDS.rds")),   times = 2),
                              microbenchmark(qread(   file = here("proc", "df9_qsave.qs")),      times = 2),
                              microbenchmark(read.fst(path = here("proc", "df9_writefst.fst")),  times = 2))

# Save the results
bind_rows(df1_read_results, df2_read_results, df3_read_results, 
          df4_read_results, df5_read_results, df6_read_results, 
          df7_read_results, df8_read_results, df9_read_results) %>%
  summary() %>% 
  data.frame() %>%
  write_csv(., path = here("proc", "read_results.csv"))


# Test the size of the saved object  --------------------------------------------------
# Make dataframe of saved csv file sizes for each data frame
csv_objects <- list.files(here("proc"), full.names = T) %>% 
  tibble(file = .) %>%
  mutate(size = file.size(file)/1e6) %>%
  mutate(file = basename(file))  %>%
  filter(grepl(".csv",file)) %>%
  mutate(file = gsub("\\..*$", "", file)) %>%
  mutate(file = gsub("sample_", "", file)) %>% 
  filter(file != "read_results" & file != "save_results") %>% 
  arrange(size)

# Visualize ----------------------------------------------------------------------------
# Plot the time to save each object
time_saved <- bind_rows(df1_results, df2_results, df3_results, 
                        df4_results, df5_results, df6_results, 
                        df7_results, df8_results, df9_results) %>%
  summary() %>% 
  data.frame() %>%
  transmute(expr, mean = mean/1000) %>% 
  mutate(func = gsub("\\(d.*$|\\(dat.*$", "", expr))  %>%
  mutate(object = str_extract(string = expr, "df[1-9]"))  %>%
  mutate(file = object) %>%
  left_join(csv_objects, by =  "file") %>%
  rename("csv_size_mb" = "size")%>%
  mutate("csv_size_mb" = log(csv_size_mb)) %>%
  ggplot(aes(x = csv_size_mb, y = mean, group = func, color = func)) + 
  geom_point() + 
  geom_line() + 
  set_theme() + 
  ylab("Average time to save (seconds)") +
  xlab("Log of original csv size (mb)")+ 
  theme(legend.position = "bottom", 
        legend.title = element_blank())
ggsave(filename = here("results", "figures", "time_saved.png"), plot = time_saved, device = png())


# Plot the size of each saved object
size_saved <- list.files(here("proc"), full.names = T) %>% 
  tibble(file = .) %>%
  mutate(saved_size = file.size(file)/1e6) %>%
  mutate(file = basename(file)) %>% 
  filter(!grepl(".csv",file)) %>%
  mutate(file = gsub("\\..*$", "", file)) %>% 
  arrange(file) %>%
  mutate(func = gsub("df[1-9]_", "", file))  %>%
  mutate(file = gsub("_.*$", "", file)) %>%
  left_join(csv_objects, by = "file") %>%
  rename("csv_original_size" = "size") %>%
  mutate(csv_original_size = log(csv_original_size)) %>%
  ggplot(aes(x = csv_original_size, y = saved_size, group = func, color = func)) + 
  geom_point() + 
  geom_line() + 
  set_theme() + 
  xlab("Log of original csv size (mb)") +
  ylab("Saved size of .rds or .qs object (mb)") + 
  theme(legend.position = "bottom", 
        legend.title = element_blank())
ggsave(filename = here("results", "figures", "size_saved.png"), plot = size_saved, device = png())


# Plot the time to read each object
time_read <- bind_rows(df1_read_results, df2_read_results, df3_read_results, 
                       df4_read_results, df5_read_results, df6_read_results, 
                       df7_read_results, df8_read_results, df9_read_results) %>%
  summary() %>% 
  data.frame() %>%
  transmute(expr, mean = mean/1000) %>% 
  mutate(func = gsub("\\(p.*$|\\(f.*$", "", expr))  %>%
  mutate(object = str_extract(string = expr, "df[1-9]"))  %>%
  mutate(file = object) %>%
  left_join(csv_objects, by =  "file") %>%
  rename("csv_size_mb" = "size") %>%
  mutate("csv_size_mb" = log(csv_size_mb)) %>%
  ggplot(aes(x = csv_size_mb, y = mean, group = func, color = func)) + 
  geom_point() + 
  geom_line() + 
  set_theme() + 
  ylab("Average time to read (seconds)") +
  xlab("Log of original csv size (mb)")+ 
  theme(legend.position = "bottom", 
        legend.title = element_blank())
ggsave(filename = here("results", "figures", "time_read.png"), plot = time_read, device = png())
