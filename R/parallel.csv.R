#' Parallel CSV Converter
#' 
#' Parallelizes the writing of separate CSV files (still sequential reading) in order to store them in \code{fst} format (also, overwrites \code{fst::threads_fst}. Requires \code{data.table} and \code{fst} packages.
#' 
#' @param file Type: vector of characters. Path to all files to read.
#' @param compress Type: numeric. Compression rate to use. Defaults to \code{35}.
#' @param progress_bar Type: logical. Whether to print a progress bar. Defaults to \code{TRUE}.
#' @param clean_mem Type: logical. Whether the force garbage collection at the end of each file read in order to reclaim RAM. Defaults to \code{FALSE}.
#' @param cl Type: cluster or integer. A parallel cluster for parallelized calls. Used only when \code{progress_bar = TRUE}. Writes to the cluster most of the variables (\code{compress}, \code{max_threads}, \code{clean_mem}, \code{wkdir}) and removes them at the end. When it is a number, creates and destroys a cluster with the specified number of parallel clusters. Defaults to \code{NULL}.
#' @param max_threads Type: numeric. The maximum number of threads allowed to adapt \code{fst::threads_fst}. Make sure the result of \code{cl} cores multiplicated by \code{max_threads} is not bigger than the number of threads in your computer. Defaults to \code{max(ifelse(is.null(cl), parallel::detectCores(), ifelse(!is.list(cl), round(parallel::detectCores() / cl), round(parallel::detectCores() / length(cl)))), 1)}, which means at least 1 thread, and adjust automatically the number of threads depending on the number of cores per cluster. Note that it takes the rounded value, which might over and under allocate threads.
#' @param wkdir Type: character. The working directory, when using a cluster. Defaults to \code{NULL}.
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
#' # parallel.csv(paste0("file_", 1:100, ".csv"), max_threads = 1, progress_bar = TRUE, cl = 8)
#' 
#' @import data.table
#' 
#' @export

parallel.csv <- function(file, compress = 35, progress_bar = TRUE, clean_mem = FALSE, cl = NULL, max_threads = max(ifelse(is.null(cl), parallel::detectCores(), ifelse(!is.list(cl), round(parallel::detectCores() / cl), round(parallel::detectCores() / length(cl)))), 1), wkdir = NULL, ...) {
  
  # Set number of threads, if available
  fst::threads_fst(nr_of_threads = max_threads)
  
  # Check for parallelism / progress bar
  if (progress_bar) {
    
    # Check whether a cluster is provided
    if (!is.null(cl)) {
      
      # If a cluster is provided, check whether we need to create one
      if (!is.list(cl)) {
        
        # Prepare to reset cluster at the end, and generate a cluster now
        stop_cluster <- TRUE
        cl <- parallel::makeCluster(cl)
        
      } else {
        
        # Do not kill the cluster at the end
        stop_cluster <- FALSE
        
      }
      
      # Set the working directory appropriately, if provided
      if (!is.null(wkdir)) {
        
        parallel::clusterExport(cl, c("compress", "max_threads", "clean_mem", "wkdir"), envir = environment())
        parallel::clusterEvalQ(cl, {setwd(wkdir)})
        
      } else {
        
        parallel::clusterExport(cl, c("compress", "max_threads", "clean_mem"), envir = environment())
        
      }
      
      # Load appropriate libraries in the cluster
      parallel::clusterEvalQ(cl, {library(data.table); library(fst)})
      
      # Read from current process
      pbapply::pblapply(file, function(x) {
        
        my_table <- data.table::fread(x)
        fst::write.fst(my_table, path = paste0(substr(x, 1, nchar(x) - 4), ".fst"), compress = compress, ...)
        if (clean_mem) {gc(verbose = FALSE)}
        return(NULL)
        
      }, cl = cl)
      
      parallel::clusterEvalQ(cl, {suppressWarnings(rm(compress, max_threads, clean_mem, wkdir))})
      
      if (stop_cluster) {parallel::stopCluster(cl)}
      
    } else {
      
      # Read from current process
      pbapply::pblapply(file, function(x) {
        
        my_table <- data.table::fread(x)
        fst::write.fst(my_table, path = paste0(substr(x, 1, nchar(x) - 4), ".fst"), compress = compress, ...)
        if (clean_mem) {gc(verbose = FALSE)}
        return(NULL)
        
      })
      
    }
    
  } else {
    
    # Read from current process
    lapply(file, function(x) {
      
      my_table <- data.table::fread(x)
      fst::write.fst(my_table, path = paste0(substr(x, 1, nchar(x) - 4), ".fst"), compress = compress, ...)
      if (clean_mem) {gc(verbose = FALSE)}
      return(NULL)
      
    })
    
  }
  
  
  invisible(NULL)
  
}
