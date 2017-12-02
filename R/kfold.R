#' (Un)Stratified k-fold for any type of label
#'
#' This function allows to create (un)stratified folds from a label vector.
#' 
#' In contrary to \code{Laurae::kfold}, please do not use \code{stratified} for regression, use \code{pseudo} instead. I had complaints about weird fold generation when using stratification with regression labels: it just does not work the way it was intended (now, use \code{stratified} for classification stratification, and \code{pseudo} for regression stratification).
#' 
#' @param y Type: numeric. The label vector (not a factor).
#' @param k Type: integer. The amount of folds to create. Causes issues if \code{length(y) < k} (e.g more folds than samples). Defaults to \code{5}.
#' @param type Type: character. Whether the folds should be \code{stratified} (keep the same label proportions for classification), \code{treatment} (make each fold exclusive according to the label vector which becomes a vector), \code{pseudo} (pseudo-random, attempts to minimize the variance between folds for regression), or \code{random} (for fully random folds). Defaults to \code{random}.
#' @param seed Type: integer. The seed for the random number generator. Defaults to \code{0}.
#' @param named Type: boolean. Whether the folds should be named. Defaults to \code{TRUE}.
#' 
#' @return A list of vectors for each fold, where an integer represents the row number.
#' 
#' @examples
#' # Reproducible Stratified folds
#' data <- 1:5000
#' folds1 <- kfold(y = data, k = 5, type = "pseudo", seed = 111)
#' folds2 <- kfold(y = data, k = 5, type = "pseudo", seed = 111)
#' identical(folds1, folds2)
#' 
#' # Treatments
#' data <- c(rep(1:50, rep(50, 50)))
#' str(kfold(y = data, k = 5, type = "treatment"))
#' 
#' # Stratified Classification
#' data <- c(rep(0, 250), rep(1, 250))
#' folds <- kfold(y = data, k = 5, type = "stratified")
#' for (i in 1:length(folds)) {
#'   print(mean(data[folds[[i]]]))
#' }
#' 
#' # Stratified Regression
#' data <- 1:5000
#' folds <- kfold(y = data, k = 5, type = "pseudo")
#' for (i in 1:length(folds)) {
#'   print(mean(data[folds[[i]]]))
#' }
#' 
#' # Stratified Multi-class Classification
#' data <- c(rep(0, 250), rep(1, 250), rep(2, 250))
#' folds <- kfold(y = data, k = 5, type = "stratified")
#' for (i in 1:length(folds)) {
#'   print(mean(data[folds[[i]]]))
#' }
#' 
#' # Unstratified Regression
#' data <- 1:5000
#' folds <- kfold(y = data, k = 5, type = "random")
#' for (i in 1:length(folds)) {
#'   print(mean(data[folds[[i]]]))
#' }
#' 
#' # Unstratified Multi-class Classification
#' data <- c(rep(0, 250), rep(1, 250), rep(2, 250))
#' folds <- kfold(y = data, k = 5, type = "random")
#' for (i in 1:length(folds)) {
#'   print(mean(data[folds[[i]]]))
#' }
#' 
#' @export

kfold <- function(y, k = 5, type = "random", seed = 0, named = TRUE) {
  
  set.seed(seed)
  
  if (type %in% c("stratified", "pseudo")) {
    
    # Stratified k-fold cross-validation
    
    if (type == "pseudo") {
      
      # Pair data in bins for pseudo-stratification for regression
      cuts <- floor(length(y) / k)
      if (cuts < 2) cuts <- 2
      if (cuts > 5) cuts <- 5
      y <- cut(y, unique(stats::quantile(y, probs = seq(0, 1, length = cuts))), include.lowest = TRUE)
      
    }
    
    if (k < length(y)) {
      
      # Bin data in factors for classification and handling regression bins
      y <- factor(as.character(y))
      numInClass <- table(y)
      foldVector <- vector(mode = "integer", length(y))
      
      # Generate folds
      for (i in 1:length(numInClass)) {
        
        seqVector <- rep(1:k, numInClass[i] %/% k)
        if (numInClass[i] %% k > 0) seqVector <- c(seqVector, sample(1:k, numInClass[i] %% k))
        foldVector[which(y == dimnames(numInClass)$y[i])] <- sample(seqVector)
        
      }
      
    } else {
      
      foldVector <- seq(along = y)
      
    }
    
    folded <- split(seq(along = y), foldVector)
    
  } else if (type == "treatment") {
    
    # Splitted k-fold cross-validation
    
    mini_y <- unique(y)
    mini_combos <- numeric(0)
    folded <- list()
    
    # Generate folds
    for (i in 1:k) {
      
      mini_combos <- sample(mini_y, floor(length(mini_y) / (k + 1 - i)))
      folded[[i]] <- which(y %in% mini_combos)
      mini_y <- mini_y[!mini_y %in% mini_combos]
      
    }
    
    
  } else if (type == "random") {
    
    # Unstratfied k-fold cross-validation
    
    mini_y <- 1:length(y)
    folded <- list()
    
    # Generate folds
    for (i in 1:k) {
      
      folded[[i]] <- sample(mini_y, floor(length(mini_y) / (k + 1 - i)))
      mini_y <- mini_y[!mini_y %in% folded[[i]]]
      
    }
    
  }
  
  if (named) {
    
    names(folded) <- paste("Fold", sprintf(paste("%0", floor(log10(k) + 1), "d", sep = ""), 1:k), sep = "")
    
  }
  
  return(folded)
  
}
