# LauraeDS: Laurae's Data Science Package

This package is the sequel to [Laurae2/Laurae](https://github.com/Laurae2/Laurae) R package.

It is meant to require less stuff and more robust.

## Installation

```r
devtools::install_github("Laurae2/LauraeDS")
```

Dependencies installation:

```r
install.packages(c("Matrix", "sparsio", "fst", "data.table", "pbapply", "parallel"))
devtools::install_github("fstpackage/fst@e060e62")
devtools::install_github("Laurae2/ez_xgb/R-package@2017-02-15-v1")
devtools::install_github("Microsoft/LightGBM/R-package@fc59fce") # Jul 14 2017, v2.0.4

```

---

## TO-DO

* [x] add parallel fast csv/fst converter
* [ ] add parallel handling (cluster, run parallel xgboost, run parallel LightGBM
* [ ] GLM (xgboost), Random Forest (xgboost, LightGBM), Gradient Boosted Trees (xgboost, LightGBM)
* [ ] grid learning ("grid search")
* [ ] Random Patches feature generation (Subsampling + Colsampling from feature groups)
* [ ] stacker
* [ ] add lot of stuff

---

## Available functions

---

### Parallel functions

Parallel functions are provided to make R fly on multi-core and multi-socket systems, provided enough RAM.

| Function | Packages | Description |
| :--- | :--- | :--- |
| parallel.csv | data.table, fst, parallel | Parallelizes and multithreads the reading of CSV files and writes to fst file format for fast reading. |
| parallel.threading | parallel | Sets processor affinity correctly on Windows machines. Provide a boost of up to 200% in memory bounded applications. |
| parallel.destroy | parallel | Stops a parallel cluster, or destroy any available clusters bound to the current R session. |


### I/O functions

I/O Functions allows to read files from sparse matrices quickly.

| Function | Packages | Description |
| :--- | :--- | :--- |
| sparse.read | sparsio, Matrix | Reads SVMLight file format (sparse matrices) |
| sparse.write | sparsio, Matrix | Writes SVMLight file format (sparse matrices) |

---

### Fold functions

Fold functions allow to generate folds for cross-validation very quickly.

| Function | Packages | Description |
| :--- | :--- | :--- |
| kfold | None | Generate cross-validated folds (stratified, treatment, pseudo-random, random) |
| nkfold | None | Generate Repeated cross-validated folds (stratified, treatment, pseudo-random, random) |

---

### Machine Learning, Binary Matrices

Generating binary matrices never got easier if you can throw lists and data.frames directly.

| Function | Packages | Description |
| :--- | :--- | :--- |
| Laurae.xgb.dmat | xgboost, Matrix | Wrapper for extensible xgb.DMatrix generation. |
| Laurae.lgb.dmat | lightgbm, Matrix | Wrapper for extensible lgb.Dataset generation. |

---

### Machine Learning, Supervised

Not remembering every existing hyperparameters? Now you can by pressing Tab to autocomplete hyperparameters.

| Function | Packages | Description |
| :--- | :--- | :--- |
| Laurae.xgb.train | xgboost, Matrix | Wrapper for xgboost Models |

---

### Machine Learning, Loss/Metrics Helpers

Creating loss/metrics can be a tedious task without templates. Use these as template wrappers: focus on loss/metrics, wrap them with a template quickly.

| Function | Packages | Description |
| :--- | :--- | :--- |
| xgb.wrap.loss | xgboost | Wrapper to make quick xgboost loss function. |
| xgb.wrap.metric | xgboost | Wrapper to make quick xgboost metric function. |
| lgb.wrap.loss | LightGBM | Wrapper to make quick LightGBM loss function. |
| lgb.wrap.metric | LightGBM | Wrapper to make quick LightGBM metric function. |

---


