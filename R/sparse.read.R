#' SVMLight file reader
#' 
#' Reads SVMLight sparse matrix file format.
#' 
#' Requires \code{Matrix} and \code{sparsio} packages.
#' 
#' @param file Type: character. Path to your SVMLight file.
#' @param type Type: character. The matrix output type, which can be \code{CsparseMatrix}, \code{RsparseMatrix}, \code{TsparseMatrix}. Defaults to \code{CsparseMatrix}.
#' @param zero_based Type: logical. Whether columns are starting from \code{0} (\code{TRUE}), or from \code{1} (\code{FALSE}). Defaults to \code{TRUE}.
#' @param ncol Type: integer. The number of columns in the sparse matrix, useful in the case your data is very sparse and you already know the number of columns.
#' 
#' @return The data from the SVMLight file.
#' 
#' @examples
#' library(Matrix)
#' sparse_matrix <- sparseMatrix(i = 1:100, j = 1:100, x = 1:100)
#' temp_file <- tempfile(fileext = ".svm")
#' sparsio::write_svmlight(x = sparse_matrix, y = rep(1, ncol(sparse_matrix)), file = temp_file)
#' sparse_matrix_read <- sparse.read(temp_file)
#' identical(sparse_matrix, sparse_matrix_read$x)
#' 
#' @export

sparse.read <- function(file, type = "CsparseMatrix", zero_based = TRUE, ncol = NULL) {
  
  sparsio::read_svmlight(file = file, type = type, zero_based = zero_based, ncol = ncol)
  
}
