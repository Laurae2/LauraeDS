#' Parallel Destruction
#' 
#' Attempt to kill the specified parallel cluster. Might have unexpected side effects when using the kill all command.
#' 
#' @param cl Type: cluster or integer. A parallel cluster. When it is a number, creates a cluster with the specified number of parallel clusters. Defaults to \code{parallel::detectCores()}.
#' @param destroy Type: logical. Whether to attempt to destroy any cluster. Might have side effects. Defaults to \code{FALSE}.
#' 
#' @return TRUE.
#' 
#' @examples
#' 
#' \dontrun{
#' # Cannot pass CRAN checks. Disabled.
#' library(parallel)
#' 
#' # Generate 2 useless clusters of 8 threads
#' cl <- parallel::makeCluster(8)
#' cl <- parallel::makeCluster(8)
#' 
#' # Attempts to stop the second cluster
#' parallel.destroy(cl)
#' 
#' # Kills any clusters
#' parallel.destroy(destroy = TRUE)
#' }
#' 
#' @export

parallel.destroy <- function(cl = NULL, destroy = FALSE) {
  
  # Stop specified cluster
  if (is.list(cl)) {
    parallel::stopCluster(cl)
  }
  
  # Destroys all clusters
  if (destroy == TRUE) {
    closeAllConnections()
  }
  
  return(TRUE)
  
}
