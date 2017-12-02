#' Parallel CSV Converter
#' 
#' Parallelizes the writing of separate CSV files (still sequential reading) in order to store them in \code{fst} format (also, overwrites \code{fst::threads_fst}. Requires \code{data.table} and \code{fst} packages.
#' 
#' @param file Type: vector of characters. Path to all files to read.
#' @param compress Type: numeric. Compression rate to use. Defaults to \code{35}.
#' @param max_threads Type: numeric. The maximum number of threads allowed to adapt \code{fst::threads_fst}. Defaults to \code{parallel::detectCores()}.
#' @param progress_bar Type: logical. Whether to print a progress bar. Defaults to \code{TRUE}.
#' @param ... Other arguments to pass to \code{fst::write.fst}.
#' 
#' @return The element or the list of \code{fst} file names.
#' 
#' @examples
#' # Do it on your own files!
#' # library(fst) # devtools::install_github("fstPackage/fst@e060e62")
#' # library(data.table)
#' # library(parallel)
#' # 
#' # parallel.csv(c("file_1.csv", "file_2.csv"), max_threads = 1, progress_bar = TRUE)
#' 
#' @import data.table
#' 
#' @export

parallel.csv <- function(file, compress = 35, max_threads = parallel::detectCores(), progress_bar = TRUE, ...) {
  
  fst::threads_fst(nr_of_threads = max_threads)
  
  if (progress_bar) {
    
    # Read from current process
    pbapply::pblapply(file, function(x) {
      
      my_table <- data.table::fread(x, nThread = max_threads, showProgress = TRUE)
      fst::write.fst(my_table, path = paste0(substr(x, 1, nchar(x) - 4), ".fst"), compress = compress, ...)
      return(NULL)
      
    })
    
  } else {
    
    # Read from current process
    lapply(file, function(x) {
      
      my_table <- data.table::fread(x, nThread = max_threads)
      fst::write.fst(my_table, path = paste0(substr(x, 1, nchar(x) - 4), ".fst"), compress = compress, ...)
      return(NULL)
      
    })
    
  }
  
  
  invisible(NULL)
  
}
