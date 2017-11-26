# LauraeDS: Laurae's Data Science Package

This package is the sequel to [Laurae2/Laurae](https://github.com/Laurae2/Laurae) R package.

It is meant to require less stuff and more robust.

Installation:

```r
devtools::install_github("Laurae2/LauraeDS")
```

Dependencies installation:

```r
install.packages(c("Matrix", "sparsio"))
devtools::install_github("Laurae2/ez_xgb/R-package@2017-02-15-v1")
devtools::install_github("Microsoft/LightGBM/R-package@fc59fce") # Jul 14 2017, v2.0.4

```

TO-DO:
- [] add parallel handling (cluster, run parallel xgboost, run parallel LightGBM
- [] GLM (xgboost), Random Forest (xgboost, LightGBM), Graident Boosted Trees (xgboost, LightGBM)
- [] grid learning ("grid search")
- [] Random Patches feature generation (Subsampling + Colsampling from feature groups)
- [] stacker
- [] add lot of stuff

Machine Learning:

| Function | Packages | --- |
| :--- | :--- | :--- |
| xgb.wrap.loss | xgboost | Wrapper to make quick xgboost loss function. |
| xgb.wrap.metric | xgboost | Wrapper to make quick xgboost metric function. |
| lgb.wrap.loss | LightGBM | Wrapper to make quick LightGBM loss function. |
| lgb.wrap.metric | LightGBM | Wrapper to make quick LightGBM metric function. |

I/O functions:

| Function | Packages | --- |
| :--- | :--- | :--- |
| sparse.read | sparsio, Matrix | Reads SVMLight file format (sparse matrices) |
| sparse.write | sparsio, Matrix | Writes SVMLight file format (sparse matrices) |

Fold functions:

| Function | Packages | --- |
| :--- | :--- | :--- |
| kfold | | Generate folds (stratified, treatment, pseudo-random, random) |
| nkfold | | Generate Repeated folds (stratified, treatment, pseudo-random, random) |
