#' Maximum binary accuracy
#' 
#' This function allows to use a custom thresholding method to maximize the binary accuracy.
#' 
#' @param preds Type: numeric. The predictions.
#' @param labels Type: numeric. The labels (0, 1).
#' @param threshold Type: logical. Whether to return the threshold. Defaults to \code{FALSE}.
#' 
#' @return A one or two element vector containing the maximum accuracy for binary data, and the threshold used if requested. Returns \code{-1} in case of errors.
#' 
#' @export

metrics.acc.max <- function(preds, labels, threshold = FALSE) {
  
  DT <- data.table::data.table(y_true = labels, y_prob = preds, key = "y_prob")
  cleaner <- !duplicated(DT[, "y_prob"], fromLast = TRUE)
  lens <- length(labels)
  nump <- sum(labels)
  
  DT[, tn_v := cumsum(y_true == 0)]
  DT[, tp_v := nump - cumsum(y_true == 1)]
  DT <- DT[cleaner, ]
  DT[, acc := (tn_v + tp_v) / lens]
  
  best_row <- which.max(DT$acc)
  
  if (length(best_row) > 0) {
    if (threshold) {
      return(c(DT$acc[best_row[1]], DT$y_prob[best_row[1]]))
    } else {
      return(DT$acc[best_row[1]])
    }
  } else {
    if (threshold) {
      return(c(-1, -1))
    } else {
      return(-1)
    }
  }
  
}
