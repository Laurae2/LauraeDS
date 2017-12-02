globalVariables(c("xgb_f")) # Workaround: xgb.wrap.metric, xgb.wrap.loss

# Machine Learning
requireNamespace("xgboost") # Workaround: xgb.wrap.metric, xgb.wrap.loss, Laurae.xgb.dmat
requireNamespace("lightgbm") # Workaround: lgb.wrap.metric, lgb.wrap.loss, Laurae.lgb.dmat

# Matrices
requireNamespace("Matrix") # Workaround: sparse.read, sparse.write, Laurae.xgb.dmat, laurae.lgb.dmat

# Input / Output
requireNamespace("sparsio") # Workaround: sparse.read, sparse.write
requireNamespace("data.table") # Workaround: parallel.csv
requireNamespace("fst") # Workaround: parallel.csv

# Parallelization
requireNamespace("pbapply") # Workaround: Laurae.xgb.dmat, Laurae.lgb.dmat, parallel.csv
requireNamespace("parallel") # Workaround: parallel.csv
