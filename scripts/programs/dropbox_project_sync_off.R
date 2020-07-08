dropbox_project_sync_off <- function() {
  require(usethis)
  this_project <- usethis::proj_get()
  
  if (grep("Dropbox", this_project) == 0) {warning("This project is not in a Dropbox folder")}
  
  dir_to_block <- paste0(this_project,"/.Rproj.user")
  file_to_block <- paste0(this_project,".Rproj")
  
  dir_to_block <- gsub("/", "\\\\", dir_to_block)
  file_to_block <- gsub("/", "\\\\", file_to_block)
  
  # Powershell command examples:
  # These set flags to prevent syncing
  # Set-Content -Path C:\Users\myname\Dropbox\mywork\test\test.Rproj -Stream com.dropbox.ignored -Value 1
  # Set-Content -Path C:\Users\myname\Dropbox\mywork\test\.Rproj.user -Stream com.dropbox.ignored -Value 1
  
  s1 <- paste0('powershell -Command \"& {Set-Content -Path ', file_to_block, ' -Stream com.dropbox.ignored -Value 1}\"')
  s2 <- paste0('powershell -Command \"& {Set-Content -Path ', dir_to_block, ' -Stream com.dropbox.ignored -Value 1}\"')
  
  shell(s1)
  shell(s2)
}

dropbox_project_sync_off()