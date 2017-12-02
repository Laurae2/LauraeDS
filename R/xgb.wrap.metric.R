#' xgboost evaluation metric wrapper
#' 
#' The wrapper works only if both the wrapper and the original evaluation metric are existing. Requires \code{Matrix} and \code{xgboost} packages.
#' 
#' @param f Type: function. The function to wrap from xgboost. Requires the following order of arguments for the function to work: \code{preds, labels}, and returns a single value.
#' @param name Type: character. The evaluation metric name which is printed and used for xgboost variables.
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
#' evalerror <- function(preds, labels) {
#'   return(mean(abs(preds - labels)))
#' }
#' evalerror_wrap <- xgb.wrap.metric(f = evalerror, "mae")
#' 
#' param <- list(max_depth = 2, eta = 1, silent = 1, nthread = 1, 
#'               objective = "binary:logistic", eval_metric = evalerror_wrap)
#' bst <- xgboost::xgb.train(param, dtrain, nrounds = 2, watchlist)
#' 
#' @export

xgb.wrap.metric <- function(f, name) {
  
  eval(parse(text = paste0("xgb_f <- function(preds, dtrain) {
  return(list(metric = '", name, "', value = ", deparse(substitute(f)), "(preds, xgboost::getinfo(dtrain, 'label'))))
}")))
  
  return(xgb_f)
  
}
