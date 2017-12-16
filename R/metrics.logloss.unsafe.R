#' Logarithmic Loss (logloss)
#' 
#' This function computes the Logarithmic loss without shrinking predictions (you may encounter infinite predictions).
#'  
#' @param preds Type: numeric. The predictions.
#' @param labels Type: numeric. The labels (0, 1).
#' @param eps Type: numeric. The shrinkage between the 0 and 1's bounds.
#' 
#' @return The Logarithmic loss.
#' 
#' @examples
#' set.seed(11111)
#' metrics.logloss.unsafe(preds = runif(10000, 0, 1), labels = round(runif(10000, 1)))
#' 
#' @export

metrics.logloss.unsafe <- function(preds, labels, eps = 1e-15) {
  (-1 / length(labels)) * (sum(labels * log(preds) + (1 - labels) * log(1 - preds)))
}
