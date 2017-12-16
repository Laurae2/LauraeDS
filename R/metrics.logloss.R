#' Logarithmic Loss (logloss)
#' 
#' This function computes the Logarithmic loss.
#'  
#' @param preds Type: numeric. The predictions.
#' @param labels Type: numeric. The labels (0, 1).
#' @param eps Type: numeric. The shrinkage to apply between the 0 and 1's bounds.
#' 
#' @return The Logarithmic loss.
#' 
#' @examples
#' set.seed(11111)
#' metrics.logloss(preds = runif(10000, 0, 1), labels = round(runif(10000, 1)))
#' 
#' @export

metrics.logloss <- function(preds, labels, eps = 1e-15) {
  predicted <- pmin(pmax(preds, eps), 1 - eps)
  (-1 / length(labels)) * (sum(labels * log(predicted) + (1 - labels) * log(1 - predicted)))
}
