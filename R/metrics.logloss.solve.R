#' Logarithmic Loss Solver
#' 
#' Reverse engineers the prediction or the positive sample ratio to provide to achieve a known loss.
#' 
#' @param to_solve Type: character. What to solve. \itemize{
#'  \item \code{"pred"} solves for the best constant prediction value provided the \code{known_loss} and \code{known_ratio}. Use \code{known_loss} as \code{0} if you want to minimize the loss function. Provide another value when reverse-engineering the prediction is required. Although the solving equation can be expressed as an exact formula (with an exact solution), the solver uses an approximate method (Brent) to fit rare cases such as loss minimization provided a single ratio.
#'  \item \code{"ratio"} solves for the best constant ratio of positives over (positives + negatives), provided the \code{known_loss} and \code{known_pred}. Use \code{known_loss} as \code{0} if you want to minimize the loss function. Provide another value when reverse-engineering the ratio is required. It uses an approximate solving method (Brent).
#' }
#' @param known_loss Type: numeric. The known loss issued from the logartihmic loss.
#' @param known_pred Type: numeric. The prediction value which must be fixed. Must be provided when \code{to_solve == "ratio"} Defaults to \code{NULL}.
#' @param known_ratio Type: numeric. The positive ratio which must be fixed. Must be provided when \code{to_solve == "pred"} Defaults to \code{NULL}.
#' 
#' @return The solved value.
#' 
#' @examples
#' # Note: this example unexpectedly fails when using pkgdown.
#' # Example from https://www.kaggle.com/opanichev/mean-baseline-lb-0-30786/code
#' # WSDM - KKBox's Churn Prediction Challenge (public score: 0.17689)
#' 
#' # Reverse engineeer ratio of positives in Public Leaderboard
#' print(metrics.logloss.solve(to_solve = "ratio",
#'                             known_loss = 0.17695680071494552,
#'                             known_pred = 0.08994191315811156), digits = 17)
#' 
#' # Reverse engineer the prediction value used in Public Leaderboard
#' print(metrics.logloss.solve(to_solve = "pred",
#'                             known_loss = 0.17695680071494552,
#'                             known_ratio = 29650 / (800000 + 29650)), digits = 17)
#' 
#' # Find better prediction value for the Public Leaderboard
#' print(metrics.logloss.solve(to_solve = "pred",
#'                             known_loss = 0,
#'                             known_ratio = 29650 / (800000 + 29650)), digits = 17)
#' cat("My better logloss: ",
#'     -1 * ((0.03573796) * log(0.03573796) + ((1 - 0.03573796) * log(1 - 0.03573796))),
#'     sep = "")
#' 
#' @export

metrics.logloss.solve <- function(to_solve,
                                  known_loss = NULL,
                                  known_pred = NULL,
                                  known_ratio = NULL) {
  
  # To solve
  logloss <- function(pred, ratio, loss) {
    abs(-1 * ((ratio) * log(pred) + ((1 - ratio) * log(1 - pred))) - loss)
  }
  
  if (to_solve == "pred" && is.null(known_pred)) {
    
    return(stats::optimize(logloss, lower = 1e-15, upper = 1 - 1e-15, maximum = FALSE, tol = .Machine$double.eps, ratio = known_ratio, loss = known_loss)$minimum)
    # return((known_loss + log(1 - known_pred)) / (log(1 - known_pred) - log(known_pred)))
    
  } else if (to_solve == "ratio" && is.null(known_ratio)) {
    
    return(stats::optimize(logloss, lower = 1e-15, upper = 1 - 1e-15, maximum = FALSE, tol = .Machine$double.eps, pred = known_pred, loss = known_loss)$minimum)
    
  } else {
    
    stop("logloss.solve: Solving something you had the answer already! (or you just put a rubbish to_solve parameter...)")
    
  }
  
}
