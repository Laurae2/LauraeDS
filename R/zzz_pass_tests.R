globalVariables(c("xgb_f")) # Workaround: xgb.wrap.metric, xgb.wrap.loss

requireNamespace("xgboost") # Workaround: xgb.wrap.metric, xgb.wrap.loss, Laurae.xgb.dmat
requireNamespace("lightgbm") # Workaround: lgb.wrap.metric, lgb.wrap.loss, Laurae.lgb.dmat

requireNamespace("Matrix") # Workaround: sparse.read, sparse.write, Laurae.xgb.dmat, laurae.lgb.dmat
requireNamespace("sparsio") # Workaround: sparse.read, sparse.write

requireNamespace("pbapply") # Workaround: Laurae.xgb.dmat, Laurae.lgb.dmat
