#' Maximum Precision (Positive Predictive Value)
#' 
#' This function allows to use a custom thresholding method to maximize the Precision (Positive Predictive Value).
#' 
#' @param preds Type: numeric. The predictions.
#' @param labels Type: numeric. The labels (0, 1).
#' @param threshold Type: logical. Whether to return the threshold. Defaults to \code{FALSE}.
#' 
#' @return A one or two element vector containing the maximum Precision (Positive Predictive Value) for binary data, and the threshold used if requested. Returns \code{-1} in case of errors.
#' 
#' @export

metrics.precision.max <- function(preds, labels, threshold = FALSE) {
  
  DT <- data.table(y_true = labels, y_prob = preds, key = "y_prob")
  cleaner <- !duplicated(DT[, "y_prob"], fromLast = TRUE)
  nump <- sum(y_true)
  
  DT[, fp_v := cumsum(y_true == 1)]
  DT[, tp_v := nump - fp_v]
  DT <- DT[cleaner, ]
  DT[, prec := tp_v / (tp_v + fp_v)]
  
  best_row <- which.max(DT$prec)
  
  if (length(best_row) > 0) {
    if (threshold) {
      return(c(DT$prec[best_row[1]], DT$y_prob[best_row[1]]))
    } else {
      return(DT$prec[best_row[1]])
    }
  } else {
    if (threshold) {
      return(c(-1, -1))
    } else {
      return(-1)
    }
  }
  
}
