globalVariables(c("xgb_f")) # Workaround: xgb.wrap.metric, xgb.wrap.loss
globalVariables(c("tn_v")) # Workaround: metrics.acc.max, metrics.fallout.max, metrics.kappa.max, metrics.mcc.max, metrics.specificity.max
globalVariables(c("y_true")) # Workaround: metrics.acc.max, metrics.f1.max, metrics.fallout.max, metrics.kappa.max, metrics.mcc.max, metrics.missrate.max, metrics.precision.max, metrics.sensitivity.max
globalVariables(c("tp_v")) # Workaround: metrics.acc.max, metrics.kappa.max
globalVariables(c("acc")) # Workaround: metrics.acc.max
globalVariables(c("fp_v")) # Workaround: metrics.f1.max, metrics.fallout.max, metrics.kappa.max, metrics.mcc.max, metrics.precision.max, metrics.specificity.max
globalVariables(c("fn_v")) # Workaround: metrics.f1.max, metrics.kappa.max, metrics.mcc.max, metrics.missrate.max, metrics.sensitivity.max
globalVariables(c("f1s")) # Workaround: metrics.f1.max
globalVariables(c("fall")) # Workaround: metrics.fallout.max
globalVariables(c("pObs")) # Workaround: metrics.kappa.max
globalVariables(c("pExp")) # Workaround: metrics.kappa.max
globalVariables(c("tp_v")) # Workaround: metrics.mcc.max, metrics.missrate.max, metrics.precision.max
globalVariables(c("mcc")) # Workaround: metrics.mcc.max
globalVariables(c("miss")) # Workaround: metrics.missrate.max
globalVariables(c("prec")) # Workaround: metrics.precision.max
globalVariables(c("sens")) # Workaround: metrics.sensitivity.max
globalVariables(c("spec")) # Workaround: metrics.specificity.max

# Statistics
requireNamespace("stats") # Workaround: metrics.logloss.solve

# Machine Learning
requireNamespace("xgboost") # Workaround: xgb.wrap.metric, xgb.wrap.loss, Laurae.xgb.dmat
requireNamespace("lightgbm") # Workaround: lgb.wrap.metric, lgb.wrap.loss, Laurae.lgb.dmat

# Matrices
requireNamespace("Matrix") # Workaround: sparse.read, sparse.write, Laurae.xgb.dmat, laurae.lgb.dmat

# Input / Output
requireNamespace("sparsio") # Workaround: sparse.read, sparse.write
requireNamespace("data.table") # Workaround: parallel.csv, metrics.acc.max, metrics.f1.max, metrics.fallout.max, metrics.kappa.max, metrics.mcc.max, metrics.missrate.max, metrics.precision.max, metrics.sensitivity.max, metrics.specificity.max
requireNamespace("fst") # Workaround: parallel.csv

# Parallelization
requireNamespace("pbapply") # Workaround: Laurae.xgb.dmat, Laurae.lgb.dmat, parallel.csv
requireNamespace("parallel") # Workaround: parallel.csv, parallel.threading, parallel.destroy
