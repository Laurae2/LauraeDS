#' (Un)Stratified Repeated k-fold for any type of label
#'
#' This function allows to create (un)stratified repeated folds from a label vector.
#' 
#' @param y Type: The label vector.
#' @param n Type: integer. The amount of repeated fold computations to perform. Defaults to \code{2}.
#' @param k Type: integer or vector of integers. The amount of folds to create. Causes issues if \code{length(y) < k} (e.g more folds than samples). If a vector of integers is supplied, then for each k-fold in the repeat N, k[N] is selected as the number of folds. Defaults to \code{5}.
#' @param type Type: character. Whether the folds should be \code{stratified} (keep the same label proportions for classification), \code{treatment} (make each fold exclusive according to the label vector which becomes a vector), \code{pseudo} (pseudo-random, attempts to minimize the variance between folds for regression), or \code{random} (for fully random folds). Defaults to \code{random}.
#' @param seed Type: integer or vector of integers. The seed for the random number generator. If a vector of integer is provided, its length should be at least longer than \code{n}. Otherwise (if an integer is supplied), it starts each fold with the provided seed, and adds 1 to the seed for every repeat. Defaults to \code{0}.
#' @param named Type: boolean. Whether the folds should be named. Defaults to \code{TRUE}.
#' @param weight Type: boolean. Whether to return the weights of each fold so their sum is equal to \code{1}. Defaults to \code{TRUE}.
#' 
#' @return A list of vectors for each fold, where an integer represents the row number, or a list of list containing \code{Folds} and \code{Weights} if \code{weight = TRUE}.
#' 
#' @examples
#' # Reproducible Stratified Repeated folds
#' data <- 1:5000
#' folds1 <- nkfold(y = data, n = 2, k = 5, type = "pseudo", seed = 111)
#' folds2 <- nkfold(y = data, n = 2, k = 5, type = "pseudo", seed = c(111, 112))
#' identical(folds1, folds2)
#' # [1] TRUE
#' 
#' # Repeated Treatments
#' data <- c(rep(1:50, rep(50, 50)))
#' str(nkfold(y = data, n = 2, k = 5, type = "treatment"))
#' # RList of 10
#' # R$ Rep1Fold1: int [1:500] 451 452 453 454 455 456 457 458 459 460 ...
#' # R$ Rep1Fold2: int [1:500] 101 102 103 104 105 106 107 108 109 110 ...
#' # R$ Rep1Fold3: int [1:500] 1 2 3 4 5 6 7 8 9 10 ...
#' # R$ Rep1Fold4: int [1:500] 151 152 153 154 155 156 157 158 159 160 ...
#' # R$ Rep1Fold5: int [1:500] 51 52 53 54 55 56 57 58 59 60 ...
#' # R$ Rep2Fold1: int [1:500] 101 102 103 104 105 106 107 108 109 110 ...
#' # R$ Rep2Fold2: int [1:500] 351 352 353 354 355 356 357 358 359 360 ...
#' # R$ Rep2Fold3: int [1:500] 1 2 3 4 5 6 7 8 9 10 ...
#' # R$ Rep2Fold4: int [1:500] 151 152 153 154 155 156 157 158 159 160 ...
#' # R$ Rep2Fold5: int [1:500] 51 52 53 54 55 56 57 58 59 60 ...
#' 
#' # Stratified Repeated Classification
#' data <- c(rep(0, 250), rep(1, 250))
#' folds <- nkfold(y = data, n = 2, k = 5, type = "stratified")
#' for (i in 1:length(folds)) {
#'   print(mean(data[folds[[i]]]))
#' }
#' # [1] 0.5
#' # [1] 0.5
#' # [1] 0.5
#' # [1] 0.5
#' # [1] 0.5
#' # [1] 0.5
#' # [1] 0.5
#' # [1] 0.5
#' # [1] 0.5
#' # [1] 0.5
#' 
#' # Stratified Repeated Regression
#' data <- 1:5000
#' folds <- nkfold(y = data, n = 2, k = 5, type = "pseudo")
#' for (i in 1:length(folds)) {
#'   print(mean(data[folds[[i]]]))
#' }
#' # [1] 2504.919
#' # [1] 2483.742
#' # [1] 2496.716
#' # [1] 2500.756
#' # [1] 2516.367
#' # [1] 2507.524
#' # [1] 2497.312
#' # [1] 2487.658
#' # [1] 2513.124
#' # [1] 2496.882
#' 
#' # Stratified Repeated Multi-class Classification
#' data <- c(rep(0, 250), rep(1, 250), rep(2, 250))
#' folds <- nkfold(y = data, n = 2, k = 5, type = "stratified")
#' for (i in 1:length(folds)) {
#'   print(mean(data[folds[[i]]]))
#' }
#' # [1] 1
#' # [1] 1
#' # [1] 1
#' # [1] 1
#' # [1] 1
#' # [1] 1
#' # [1] 1
#' # [1] 1
#' # [1] 1
#' # [1] 1
#' 
#' # Unstratified Repeated Regression
#' data <- 1:5000
#' folds <- nkfold(y = data, n = 2, k = 5, type = "random")
#' for (i in 1:length(folds)) {
#'   print(mean(data[folds[[i]]]))
#' }
#' # [1] 2527.465
#' # [1] 2446.88
#' # [1] 2518.532
#' # [1] 2502.391
#' # [1] 2507.232
#' # [1] 2534.823
#' # [1] 2419.476
#' # [1] 2545.736
#' # [1] 2467.211
#' # [1] 2535.254
#' 
#' # Unstratified Repeated Multi-class Classification
#' data <- c(rep(0, 250), rep(1, 250), rep(2, 250))
#' folds <- nkfold(y = data, n = 2, k = 5, type = "random")
#' for (i in 1:length(folds)) {
#'   print(mean(data[folds[[i]]]))
#' }
#' # [1] 0.9866667
#' # [1] 0.96
#' # [1] 1.066667
#' # [1] 0.92
#' # [1] 1.066667
#' # [1] 0.9866667
#' # [1] 0.9533333
#' # [1] 1.066667
#' # [1] 1.026667
#' # [1] 0.9666667
#' 
#' # Stratified Repeated 3-5-10 fold Cross-Validation all in one
#' data <- c(rep(0, 250), rep(1, 250), rep(2, 250))
#' str(nkfold(data, n = 3, k = c(3, 5, 10), "random"))
#' # List of 18
#' # $ Rep1Fold01: int [1:250] 673 199 279 428 678 151 669 702 491 467 ...
#' # $ Rep1Fold02: int [1:250] 709 574 700 351 448 362 76 183 371 265 ...
#' # $ Rep1Fold03: int [1:250] 30 411 529 492 497 358 720 305 617 559 ...
#' # $ Rep2Fold01: int [1:150] 200 279 429 679 151 670 703 491 467 46 ...
#' # $ Rep2Fold02: int [1:150] 466 422 243 342 380 127 400 53 202 154 ...
#' # $ Rep2Fold03: int [1:150] 513 60 383 354 290 739 125 609 41 307 ...
#' # $ Rep2Fold04: int [1:150] 731 347 291 117 25 487 435 750 444 30 ...
#' # $ Rep2Fold05: int [1:150] 621 688 93 545 693 692 244 272 681 56 ...
#' # $ Rep3Fold01: int [1:75] 139 527 429 126 705 703 97 620 348 408 ...
#' # $ Rep3Fold02: int [1:75] 564 221 650 304 427 264 499 20 301 153 ...
#' # $ Rep3Fold03: int [1:75] 138 277 675 303 580 219 636 129 57 223 ...
#' # $ Rep3Fold04: int [1:75] 635 680 370 528 611 503 267 653 398 639 ...
#' # $ Rep3Fold05: int [1:75] 622 375 336 651 567 42 156 507 659 34 ...
#' # $ Rep3Fold06: int [1:75] 494 220 744 511 47 84 371 358 226 74 ...
#' # $ Rep3Fold07: int [1:75] 509 560 356 112 613 625 287 722 726 467 ...
#' # $ Rep3Fold08: int [1:75] 26 748 498 197 648 65 695 707 103 470 ...
#' # $ Rep3Fold09: int [1:75] 258 81 251 170 510 105 41 167 471 389 ...
#' # $ Rep3Fold10: int [1:75] 596 654 741 442 127 406 99 432 215 77 ...
#' 
#' @export

nkfold <- function(y, n = 2, k = 5, type = "random", seed = 0, named = TRUE, weight = FALSE) {
  
  folds <- list()
  
  if (length(k) == 1) {
    k <- rep(k, n)
  }
  
  if (weight) {
    
    list_weight <- numeric(0)
    nmind <- 0
    for (i in 1:n) {
      folded <- kfold(y = y, k = k[i], type = type, seed = ifelse(length(seed) == 1, seed + i - 1, seed[i]), named = FALSE)
      for (j in 1:k[i]) {
        nmind <- nmind + 1
        folds[[length(folds) + 1]] <- folded[[j]]
        names(folds)[length(folds)] <- paste("Rep", sprintf(paste("%0", floor(log10(n) + 1), "d", sep = ""), i), "Fold", sprintf(paste("%0", floor(log10(max(k)) + 1), "d", sep = ""), j), sep = "")
        list_weight[nmind] <- 1 / k[i] / n
      }
    }
    
    folds <- list(Folds = folds, Weights = list_weight)
    
  } else {
    
    for (i in 1:n) {
      folded <- kfold(y = y, k = k[i], type = type, seed = ifelse(length(seed) == 1, seed + i - 1, seed[i]), named = FALSE)
      for (j in 1:k[i]) {
        folds[[length(folds) + 1]] <- folded[[j]]
        names(folds)[length(folds)] <- paste("Rep", sprintf(paste("%0", floor(log10(n) + 1), "d", sep = ""), i), "Fold", sprintf(paste("%0", floor(log10(max(k)) + 1), "d", sep = ""), j), sep = "")
      }
    }
    
  }
  
  
  return(folds)
  
}
