#' Maximum Specificity (True Negative Rate)
#' 
#' This function allows to use a custom thresholding method to maximize the Specificity (True Negative Rate).
#' 
#' @param preds Type: numeric. The predictions.
#' @param labels Type: numeric. The labels (0, 1).
#' @param threshold Type: logical. Whether to return the threshold. Defaults to \code{FALSE}.
#' 
#' @return A one or two element vector containing the maximum Specificity (True Negative Rate) for binary data, and the threshold used if requested. Returns \code{-1} in case of errors.
#' 
#' @export

metrics.specificity.max <- function(preds, labels, threshold = FALSE) {
  
  DT <- data.table(y_true = labels, y_prob = preds, key = "y_prob")
  cleaner <- !duplicated(DT[, "y_prob"], fromLast = TRUE)
  
  DT[, tn_v := as.numeric(cumsum(y_true == 0))]
  DT[, fp_v := cumsum(y_true == 1)]
  DT <- DT[cleaner, ]
  DT[, spec := tn_v / (tn_v + fp_v)]
  
  best_row <- which.max(DT$spec)
  
  if (length(best_row) > 0) {
    if (threshold) {
      return(c(DT$spec[best_row[1]], DT$y_prob[best_row[1]]))
    } else {
      return(DT$spec[best_row[1]])
    }
  } else {
    if (threshold) {
      return(c(-1, -1))
    } else {
      return(-1)
    }
  }
  
}
