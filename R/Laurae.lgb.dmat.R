#' LightGBM Dataset generation
#' 
#' Geneartes a (list of) lgb.Dataset. Unsupported for clusters.
#' 
#' Requires \code{Matrix} and \code{lightgbm} packages.
#' 
#' @param data Type: matrix or dgCMatrix or data.frame or data.table or filename, or potentially a list of any of them. When a list is provided, it generates the appropriate \code{lgb.Dataset} for all the sets. The data to convert to \code{lgb.Dataset}. RAM usage required is 2x the current \code{data} input RAM usage, and 3x for \code{data.frame} and \code{data.table} due to internal matrix conversion added before binary matrix generation.
#' @param label Type: numeric, or a list of numeric. The label of associated rows in \code{data}.
#' @param missing Type: numeric. The value used to represent missing values in \code{data}. Defaults to \code{NA} (and missing values for \code{dgCMatrix}).
#' @param save_names Type: character or NULL, or a list of characters. If names are provided, the generated \code{lgb.Dataset} are stored physically to the drive. When a list is provided (along with a list of \code{data} and \code{labels}), it stores files sequentially by name if a list is provided for \code{data} but not for \code{save_names}. Defaults to \code{NA}.
#' @param save_keep Type: logical, or a list of logicals. When names are provided, \code{save_keep} allows to selectively choose the \code{lgb.Dataset} to retain for returning to the user. Useful when generating a list of \code{lgb.Dataset} but choosing to keep only a part of them. When \code{FALSE}, it returns a \code{NULL} instead of the \code{lgb.Dataset}. Defaults to \code{TRUE}.
#' @param progress_bar Type: logical. Whether to print a progress bar in case of list inputs. Defaults to \code{TRUE}.
#' @param clean_mem Type: logical. Whether the force garbage collection at the end of each matrix construction in order to reclaim RAM. Defaults to \code{FALSE}.
#' @param ... More arguments to pass to \code{lightgbm::lgb.Dataset}.
#' 
#' @return The lgb.Dataset
#' 
#' @examples
#' library(Matrix)
#' library(lightgbm)
#' 
#' set.seed(0)
#' 
#' # Generate lgb.Dataset from matrix
#' random_mat <- matrix(runif(1000000, 0, 1), nrow = 100000)
#' random_labels <- runif(100000, 0, 1)
#' lgb_from_mat <- Laurae.lgb.dmat(data = random_mat, label = random_labels, missing = NA)
#' 
#' # Generate lgb.Dataset from data.frame
#' random_df <- data.frame(random_mat)
#' random_labels_2 <- runif(100000, 0, 1)
#' lgb_from_df <- Laurae.lgb.dmat(data = random_df, label = random_labels, missing = NA)
#' 
#' # Generate lgb.Dataset from respective elements of a list with progress bar
#' # while keeping memory usage as low as theoretically possible
#' random_list <- list(random_mat, random_df)
#' random_labels_3 <- list(random_labels, random_labels_2)
#' lgb_from_list <- Laurae.lgb.dmat(data = random_list,
#'                                  label = random_labels_3,
#'                                  missing = NA,
#'                                  progress_bar = TRUE,
#'                                  clean_mem = TRUE)
#' #    |++++++++++++++++++++++++++++++++++++++++++++++++++| 100% elapsed = 00s
#' 
#' # Generate lgb.Dataset from respective elements of a list and keep only first
#' # while keeping memory usage as low as theoretically possible
#' lgb_from_list <- Laurae.lgb.dmat(data = random_list,
#'                                  label = random_labels_3,
#'                                  missing = NA,
#'                                  save_keep = c(TRUE, FALSE),
#'                                  clean_mem = TRUE)
#' 
#' @export

Laurae.lgb.dmat <- function(data, label, missing = NA, save_names = NULL, save_keep = TRUE, clean_mem = FALSE, progress_bar = TRUE, ...) {
  
  if (class(data) == "list") {
    
    if (progress_bar) {
      
      return(pbapply::pblapply(1:length(data), function(i) {
        
        # Single data (no list)
        if (class(data[[i]]) == "data.frame") {
          
          # Generate data
          temp_data <- as.matrix(data[[i]])
          if (clean_mem) {gc(verbose = FALSE)}
          to_ret <- lightgbm::lgb.Dataset(temp_data, label = label[[i]], missing = ifelse(length(missing) == 1, missing, missing[[i]]), ...)
          rm(temp_data)
          
          # Parameter return
          if (clean_mem) {gc(verbose = FALSE)}
          if (!is.null(save_names)) {lightgbm::lgb.Dataset.save(to_ret, ifelse(length(save_names) == 1, paste0(save_names, "_", i), save_names[[i]]))}
          if (ifelse(length(save_keep) == 1, save_keep, save_keep[[i]]) == TRUE) {return(to_ret)} else {return(NULL)}
          
        } else {
          
          # Generate data
          to_ret <- lightgbm::lgb.Dataset(data[[i]], label = label[[i]], missing = ifelse(length(missing) == 1, missing, missing[[i]]), ...)
          
          # Parameter return
          if (clean_mem) {gc(verbose = FALSE)}
          if (!is.null(save_names)) {lightgbm::lgb.Dataset.save(to_ret, ifelse(length(save_names) == 1, paste0(save_names, "_", i), save_names[[i]]))}
          if (ifelse(length(save_keep) == 1, save_keep, save_keep[[i]]) == TRUE) {return(to_ret)} else {return(NULL)}
          
        }
        
      }))
      
    } else {
      
      return(lapply(1:length(data), function(i) {
        
        # Single data (no list)
        if (class(data[[i]]) == "data.frame") {
          
          # Generate data
          temp_data <- as.matrix(data[[i]])
          if (clean_mem) {gc(verbose = FALSE)}
          to_ret <- lightgbm::lgb.Dataset(temp_data, label = label[[i]], missing = ifelse(length(missing) == 1, missing, missing[[i]]), ...)
          rm(temp_data)
          
          # Parameter return
          if (clean_mem) {gc(verbose = FALSE)}
          if (!is.null(save_names)) {lightgbm::lgb.Dataset.save(to_ret, ifelse(length(save_names) == 1, paste0(save_names, "_", i), save_names[[i]]))}
          if (ifelse(length(save_keep) == 1, save_keep, save_keep[[i]]) == TRUE) {return(to_ret)} else {return(NULL)}
          
        } else {
          
          # Generate data
          to_ret <- lightgbm::lgb.Dataset(data[[i]], label = label[[i]], missing = ifelse(length(missing) == 1, missing, missing[[i]]), ...)
          
          # Parameter return
          if (clean_mem) {gc(verbose = FALSE)}
          if (!is.null(save_names)) {lightgbm::lgb.Dataset.save(to_ret, ifelse(length(save_names) == 1, paste0(save_names, "_", i), save_names[[i]]))}
          if (ifelse(length(save_keep) == 1, save_keep, save_keep[[i]]) == TRUE) {return(to_ret)} else {return(NULL)}
          
        }
        
      }))
      
    }
    
  } else {
    
    # Single data (no list)
    if (class(data) == "data.frame") {
      
      # Generate data
      temp_data <- as.matrix(data)
      if (clean_mem) {gc(verbose = FALSE)}
      to_ret <- lightgbm::lgb.Dataset(temp_data, label = label, missing = missing, ...)
      rm(temp_data)
      
      # Parameter return
      if (clean_mem) {gc(verbose = FALSE)}
      if (!is.null(save_names)) {lightgbm::lgb.Dataset.save(to_ret, save_names)}
      if (save_keep == TRUE) {return(to_ret)} else {return(NULL)}
      
    } else {
      
      # Generate data
      to_ret <- lightgbm::lgb.Dataset(data, label = label, missing = missing, ...)
      
      # Parameter return
      if (clean_mem) {gc(verbose = FALSE)}
      if (!is.null(save_names)) {lightgbm::lgb.Dataset.save(to_ret, save_names)}
      if (save_keep == TRUE) {return(to_ret)} else {return(NULL)}
      
    }
    
  }
  
}
