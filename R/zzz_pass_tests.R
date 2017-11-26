globalVariables(c("xgb_f")) # Workaround: xgb.wrap.metric, xgb.wrap.loss

requireNamespace("xgboost") # Workaround: xgb.wrap.metric, xgb.wrap.loss
requireNamespace("lightgbm") # Workaround: lgb.wrap.metric, lgb.wrap.loss

requireNamespace("Matrix") # Workaround: sparse.read, sparse.write
requireNamespace("sparsio") # Workaround: sparse.read, sparse.write
