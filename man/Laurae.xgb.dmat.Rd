% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/Laurae.xgb.dmat.R
\name{Laurae.xgb.dmat}
\alias{Laurae.xgb.dmat}
\title{xgboost DMatrix generation}
\usage{
Laurae.xgb.dmat(data, label, missing = NA, save_names = NULL,
  save_keep = TRUE, clean_mem = FALSE, progress_bar = TRUE, ...)
}
\arguments{
\item{data}{Type: matrix or dgCMatrix or data.frame or data.table or filename, or potentially a list of any of them. When a list is provided, it generates the appropriate \code{xgb.DMatrix} for all the sets. The data to convert to \code{xgb.DMatrix}. RAM usage required is 2x the current \code{data} input RAM usage, and 3x for \code{data.frame} and \code{data.table} due to internal matrix conversion added before binary matrix generation.}

\item{label}{Type: numeric, or a list of numeric. The label of associated rows in \code{data}. Use \code{NULL} for passing no labels.}

\item{missing}{Type: numeric. The value used to represent missing values in \code{data}. Defaults to \code{NA} (and missing values for \code{dgCMatrix}).}

\item{save_names}{Type: character or NULL, or a list of characters. If names are provided, the generated \code{xgb.DMatrix} are stored physically to the drive. When a list is provided (along with a list of \code{data} and \code{labels}), it stores files sequentially by name if a list is provided for \code{data} but not for \code{save_names}. Defaults to \code{NA}.}

\item{save_keep}{Type: logical, or a list of logicals. When names are provided, \code{save_keep} allows to selectively choose the \code{xgb.DMatrix} to retain for returning to the user. Useful when generating a list of \code{xgb.DMatrix} but choosing to keep only a part of them. When \code{FALSE}, it returns a \code{NULL} instead of the \code{xgb.DMatrix}. Defaults to \code{TRUE}.}

\item{clean_mem}{Type: logical. Whether the force garbage collection at the end of each matrix construction in order to reclaim RAM. Defaults to \code{FALSE}.}

\item{progress_bar}{Type: logical. Whether to print a progress bar in case of list inputs. Defaults to \code{TRUE}.}

\item{...}{More arguments to pass to \code{xgboost::xgb.DMatrix}.}
}
\value{
The xgb.DMatrix
}
\description{
Geneartes a (list of) xgb.DMatrix. Supported for clusters. Requires \code{Matrix} and \code{xgboost} packages.
}
\examples{
library(Matrix)
library(xgboost)

set.seed(0)

# Generate xgb.DMatrix from matrix
random_mat <- matrix(runif(10000, 0, 1), nrow = 1000)
random_labels <- runif(1000, 0, 1)
xgb_from_mat <- Laurae.xgb.dmat(data = random_mat, label = random_labels, missing = NA)

# Generate xgb.DMatrix from data.frame
random_df <- data.frame(random_mat)
random_labels_2 <- runif(1000, 0, 1)
xgb_from_df <- Laurae.xgb.dmat(data = random_df, label = random_labels, missing = NA)

# Generate xgb.DMatrix from respective elements of a list with progress bar
# while keeping memory usage as low as theoretically possible
random_list <- list(random_mat, random_df)
random_labels_3 <- list(random_labels, random_labels_2)
xgb_from_list <- Laurae.xgb.dmat(data = random_list,
                                 label = random_labels_3,
                                 missing = NA,
                                 progress_bar = TRUE,
                                 clean_mem = TRUE)

# Generate xgb.DMatrix from respective elements of a list and keep only first
# while keeping memory usage as low as theoretically possible
xgb_from_list <- Laurae.xgb.dmat(data = random_list,
                                 label = random_labels_3,
                                 missing = NA,
                                 save_keep = c(TRUE, FALSE),
                                 clean_mem = TRUE)

}
