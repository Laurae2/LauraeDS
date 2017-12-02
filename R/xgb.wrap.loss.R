#' xgboost loss function wrapper
#' 
#' The wrapper works only if both the wrapper and the original loss metric are existing. Requires \code{Matrix} and \code{xgboost} packages.
#' 
#' @param f Type: function. The function to wrap from xgboost. Requires the following order of arguments for the function to work: \code{preds, labels}, and returns a vector of the same length of both the inputs.
#' 
#' @return The wrapping function.
#' 
#' @examples
#' # Note: this example unexpectedly fails when using pkgdown.
#' 
#' library(xgboost)
#' library(Matrix)
#' data(agaricus.train, package = "xgboost")
#' data(agaricus.test, package = "xgboost")
#' 
#' dtrain <- xgboost::xgb.DMatrix(agaricus.train$data, label = agaricus.train$label)
#' dtest <- xgboost::xgb.DMatrix(agaricus.test$data, label = agaricus.test$label)
#' watchlist <- list(train = dtrain, eval = dtest)
#' 
#' cross_entropy <- function(preds, labels) {
#'   preds <- 1 / (1 + exp(-preds))
#'   grad <- preds - labels
#'   hess <- preds * (1 - preds)
#'   return(list(grad = grad, hess = hess))
#' }
#' cross_entropy_wrap <- xgb.wrap.loss(f = cross_entropy)
#' 
#' param <- list(max_depth = 2, eta = 1, silent = 1, nthread = 1, 
#'               objective = cross_entropy_wrap, eval_metric = "auc")
#' bst <- xgboost::xgb.train(param, dtrain, nrounds = 2, watchlist)
#' 
#' # Note: this example unexpectedly fails when using pkgdown.
#' 
#' @export

xgb.wrap.loss <- function(f) {
  
  eval(parse(text = paste0("xgb_f <- function(preds, dtrain) {
  return(", deparse(substitute(f)), "(preds, xgboost::getinfo(dtrain, 'label')))
}")))
  
  return(xgb_f)
  
}
