# Load useful libraries for development
library(devtools)
library(roxygen2) # devtools::install_github("klutometis/roxygen")
library(pkgdown) # devtools::install_github("hadley/pkgdown")

# Set the working directory to where I am
setwd("E:/GitHub/LauraeDS")

# Generate documentation
document()

# Check for errors
devtools::check(document = FALSE)

# Build static website
pkgdown::build_site()

# Install package
install()
