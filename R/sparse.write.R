#' SVMLight file writer
#' 
#' Writes SVMLight sparse matrix file format. Requires \code{Matrix} and \code{sparsio} packages.
#' 
#' @param file Type: character. Path to your SVMLight file.
#' @param x Type: any supported sparse matrix. The sparse matrix to write as SVMLight file format. Defaults to \code{numeric(nrow(x))}.
#' @param y Type: integer vector. The labels associated to the corresponding rows.
#' @param zero_based Type: logical. Whether columns are starting from \code{0} (\code{TRUE}), or from \code{1} (\code{FALSE}). Defaults to \code{TRUE}.
#' 
#' @return TRUE when the function returns.
#' 
#' @examples
#' library(Matrix)
#' sparse_matrix <- sparseMatrix(i = 1:100, j = 1:100, x = 1:100)
#' temp_file <- tempfile(fileext = ".svm")
#' sparse.write(file = temp_file, x = sparse_matrix, y = rep(1, ncol(sparse_matrix)))
#' sparse_matrix_read <- sparsio::read_svmlight(temp_file)
#' identical(sparse_matrix, sparse_matrix_read$x)
#' 
#' @export

sparse.write <- function(file, x, y = numeric(nrow(x)), zero_based = TRUE) {
  
  sparsio::write_svmlight(x = x, y = y, file = file, zero_based = zero_based)
  
}
