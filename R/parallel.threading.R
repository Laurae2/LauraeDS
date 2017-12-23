#' Parallel Threading Affinity Optimization
#' 
#' Generate a cluster and optimizes the affinity of the provided cluster to perform NUMA-like optimization and avoid as much as possible inter-core communication. Basically, makes core selection sequential in the order of provided clusters. Currently works only on Windows!!!
#' 
#' @param cl Type: cluster or integer. A parallel cluster. When it is a number, creates a cluster with the specified number of parallel clusters. Defaults to \code{parallel::detectCores()}.
#' @param max_threads Type: numeric. The maximum number of threads allowed (for all clusters together, not for each cluster). Make sure the result of \code{max_threads} cores divided by \code{cl} is an integer number, while \code{max_threads} is smaller or equal to the number of (logical) cores in your computer. Defaults to \code{parallel::detectCores()}, which means use all available (logical) cores.
#' @param first_thread Type: numeric. The first core to use as the first thread to setup affinity. Useless for NUMA environments when using multiple R scripts. Defaults to \code{1}.
#' 
#' @return The cluster itself.
#' 
#' @examples
#' \dontrun{
#' # Cannot pass CRAN checks. Disabled.
#' library(parallel)
#' 
#' # Core 1-2, Core 3-4, Core 5-6, Core 7-8
#' cl <- parallel.threading(cl = 4, max_threads = 8)
#' stopCluster(cl)
#' 
#' # Core 5-6, Core 7-8
#' cl <- parallel.threading(cl = 2, max_threads = 4, first_thread = 4)
#' stopCluster(cl)
#' }
#' 
#' @export

parallel.threading <- function(cl = parallel::detectCores(),
                               max_threads = parallel::detectCores(),
                               first_thread = 1) {
  
  if (is.list(cl)) {
    
    max_xthreads <- max_threads / length(cl)
    parallel::clusterExport(cl, c("max_xthreads", "max_threads", "first_thread"), envir = environment())
    pbapply::pblapply(1:(max_threads / max_xthreads), function(x) {
      cores <- rep(FALSE, max_threads + first_thread - 1)
      if (max_xthreads) {
        cores[((x * max_xthreads - (max_xthreads - 1)):(x * max_xthreads)) + (first_thread - 1)] <- TRUE
      } else {
        cores[x] <- TRUE
      }
      affinity <- sum(cores * 2 ^ ((1:length(cores)) - 1))
      shell(paste("PowerShell -Command \"& {(Get-Process -id ", Sys.getpid(), ").ProcessorAffinity = ", affinity, "}\"", sep = ""))
      rm(cores, affinity)
    }, cl = cl)
    parallel::clusterEvalQ(cl, {suppressWarnings(rm(max_threads, max_xthreads, first_thread))})
    
  } else {
    
    cl <- parallel::makeCluster(cl)
    max_xthreads <- max_threads / length(cl)
    parallel::clusterExport(cl, c("max_xthreads", "max_threads", "first_thread"), envir = environment())
    pbapply::pblapply(1:(max_threads / max_xthreads), function(x) {
      cores <- rep(FALSE, max_threads + first_thread - 1)
      if (max_xthreads) {
        cores[((x * max_xthreads - (max_xthreads - 1)):(x * max_xthreads)) + (first_thread - 1)] <- TRUE
      } else {
        cores[x] <- TRUE
      }
      affinity <- sum(cores * 2 ^ ((1:length(cores)) - 1))
      shell(paste("PowerShell -Command \"& {(Get-Process -id ", Sys.getpid(), ").ProcessorAffinity = ", affinity, "}\"", sep = ""))
      rm(cores, affinity)
    }, cl = cl)
    parallel::clusterEvalQ(cl, {suppressWarnings(rm(max_threads, max_xthreads, first_thread))})
    
  }
  
  return(cl)
  
}
