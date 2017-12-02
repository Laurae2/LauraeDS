#' LightGBM loss function wrapper
#' 
#' The wrapper works only if both the wrapper and the original loss metric are existing. Requires \code{Matrix} and \code{lightgbm} packages.
#' 
#' @param f Type: function. The function to wrap from LightGBM. Requires the following order of arguments for the function to work: \code{preds, labels}, and returns a vector of the same length of both the inputs.
#' 
#' @return The wrapping function.
#' 
#' @examples
#' # Note: this example unexpectedly fails when using pkgdown.
#' 
#' library(lightgbm)
#' library(Matrix)
#' data(agaricus.train, package = "lightgbm")
#' train <- agaricus.train
#' dtrain <- lgb.Dataset(train$data, label = train$label)
#' 
#' cross_entropy <- function(preds, labels) {
#'   preds <- 1 / (1 + exp(-preds))
#'   grad <- preds - labels
#'   hess <- preds * (1 - preds)
#'   return(list(grad = grad, hess = hess))
#' }
#' cross_entropy_wrap <- lgb.wrap.loss(f = cross_entropy)
#' params <- list(learning_rate = 1, min_data = 1, nthread = 1)
#' 
#' set.seed(1)
#' model <- lgb.cv(params,
#'                 dtrain,
#'                 2,
#'                 nfold = 5,
#'                 obj = cross_entropy_wrap,
#'                 metric = "auc")
#' 
#' @export

lgb.wrap.loss <- function(f) {
  
  eval(parse(text = paste0("xgb_f <- function(preds, dtrain) {
  return(", deparse(substitute(f)), "(preds, lightgbm::getinfo(dtrain, 'label')))
}")))
  
  return(xgb_f)
  
}
