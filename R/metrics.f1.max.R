#' Maximum F1 Score (Precision with Sensitivity harmonic mean)
#' 
#' This function allows to use a custom thresholding method to maximize the Maximum F1 Score (Precision with Sensitivity harmonic mean).
#' 
#' @param preds Type: numeric. The predictions.
#' @param labels Type: numeric. The labels (0, 1).
#' @param threshold Type: logical. Whether to return the threshold. Defaults to \code{FALSE}.
#' 
#' @return A one or two element vector containing the maximum Maximum F1 Score (Precision with Sensitivity harmonic mean) for binary data, and the threshold used if requested. Returns \code{-1} in case of errors.
#' 
#' @export

metrics.f1.max <- function(preds, labels, threshold = FALSE) {
  
  DT <- data.table::data.table(y_true = labels, y_prob = preds, key = "y_prob")
  cleaner <- !duplicated(DT[, "y_prob"], fromLast = TRUE)
  nump <- sum(labels)
  numn <- length(labels) - nump
  
  DT[, fp_v := cumsum(y_true == 1)]
  DT[, fn_v := numn - as.numeric(cumsum(y_true == 0))]
  DT[, tp_v := nump - fp_v]
  DT <- DT[cleaner, ]
  DT[, f1s := 2 * tp_v / (2 * tp_v + fp_v + fn_v)]
  
  best_row <- which.max(DT$f1s)
  
  if (length(best_row) > 0) {
    if (threshold) {
      return(c(DT$f1s[best_row[1]], DT$y_prob[best_row[1]]))
    } else {
      return(c(DT$f1s[best_row[1]]))
    }
  } else {
    if (threshold) {
      return(c(-1, -1))
    } else {
      return(-1)
    }
  }
  
}
