#' LightGBM evaluation metric wrapper
#' 
#' The wrapper works only if both the wrapper and the original evaluation metric are existing.
#' 
#' @param f Type: function. The function to wrap from LightGBM. Requires the following order of arguments for the function to work: \code{preds, labels}, and returns a single value.
#' @param name Type: character. The evaluation metric name which is printed and used for LightGBM variables.
#' @param higher_better Type: logical. Whether a higher value means it is better. Defaults to \code{FALSE}.
#' 
#' @return The wrapping function.
#' 
#' @examples
#' library(lightgbm)
#' data(agaricus.train, package = "lightgbm")
#' train <- agaricus.train
#' dtrain <- lgb.Dataset(train$data, label = train$label)
#' 
#' evalerror <- function(preds, labels) {
#'   return(mean(abs(preds - labels)))
#' }
#' evalerror_wrap <- lgb.wrap.metric(f = evalerror, "mae", FALSE)
#' params <- list(learning_rate = 1, min_data = 1, nthread = 1)
#' 
#' set.seed(1)
#' model <- lgb.cv(params,
#'                 dtrain,
#'                 2,
#'                 nfold = 5,
#'                 objective = "regression",
#'                 eval = evalerror_wrap)
#' # [1]:	valid's mae:1.19113e-08+3.07441e-09 
#' # [2]:	valid's mae:2.18733e-16+1.80747e-16
#' 
#' @export

lgb.wrap.metric <- function(f, name, higher_better = FALSE) {
  
  eval(parse(text = paste0("xgb_f <- function(preds, dtrain) {
  return(list(name = '", name, "', value = ", deparse(substitute(f)), "(preds, lightgbm::getinfo(dtrain, 'label')), higher_better = ", higher_better, "))
}")))
  
  return(xgb_f)
  
}
