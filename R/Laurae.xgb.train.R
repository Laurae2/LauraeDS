#' xgboost Model Trainer
#' 
#' Trains an xgboost model. Requires \code{Matrix} and \code{xgboost} packages.
#' 
#' The following parameters were removed the following reasons: \itemize{
#'  \item {\code{debug_verbose}}{was a parameter added to debug Laurae's code for several xgboost GitHub issues.}
#'  \item {\code{colsample_bylevel}}{is significantly weaker than \code{colsample_bytree}.}
#'  \item {\code{sparse_threshold}}{is a mysterious \code{"hist"} parameter.}
#'  \item {\code{max_conflict_rate}}{is a \code{"hist"} specific feature bundling parameter.}
#'  \item {\code{max_search_group}}{is a \code{"hist"} specific feature bundling parameter.}
#'  \item {\code{base_margin}}{is an unusual hyperparameter which should be used for guaranteeing faster convergence.}
#'  \item {\code{num_class}}{is a parameter which must be added by yourself for multiclass problems.}
#'  \item {\code{enable_feature_grouping}}{is not available in every xgboost version.}
#'  \item {\code{sketch_eps}}{because \code{"approx"} method is obsolete since \code{"hist"} exists.}
#'  \item {\code{max_delta_step}}{should be defined by yourself only when you need it (especially for Poisson regression which has exploding gradients)}.
#'  \item {\code{tweedie_variance_power}}{should be defined by yourself when you are optimizing Tweedie distribution objectives}.
#'  \item {\code{updater}}{because we don't expect you to modify the sequence of tree updates, as xgboost automatically defines it.}
#'  \item {\code{refresh_leaf}}{because we are not only updating node statistics.}
#'  \item {\code{process_type}}{because we let xgboost do its job.}
#'  \item {\code{???}}{because I might have missed some other important parameters.}
#' }
#' 
#' You may add them without any issues unlike other parameters.
#' 
#' @param train Type: xgb.DMatrix. The training data.
#' @param watchlist Type: list of xgb.DMatrix. The data to monitor through the metrics, defaults to \code{list()}.
#' @param clean_mem Type: logical. Whether the force garbage collection before and after training in order to reclaim RAM. Defaults to \code{FALSE}.
#' @param seed Type: numeric. Seed for the random number generator for reproducibility, defaults to \code{1}.
#' @param verbose Type: numeric. Whether to print messages. Defaults to \code{1}.
#' @param verbose_iterations Type: numeric. How many iterations to cool down before printing on the console again. Defaults to \code{1}.
#' @param objective Type: character or function. The objective to optimize, defaults to \code{reg:linear}. \itemize{
#'  \item {\code{"reg:linear"}}{Linear Regression.}
#'  \item {\code{"reg:logistic"}}{Logistic Regression.}
#'  \item {\code{"binary:logistic"}}{Logistic Regression (binary classification, probabilities).}
#'  \item {\code{"binary:logitraw"}}{Logistic Regression (binary classification, raw score).}
#'  \item {\code{"multi:softmax"}}{Multiclass Logistic Regression (multiclass classification, best class).}
#'  \item {\code{"multi:softprob"}}{Multiclass Logistic Regression (multiclass classification, probability matrix).}
#'  \item {\code{"rank:pairwise"}}{LambdaMART-like Ranking (pairwise loss).}
#'  \item {\code{"count:poisson"}}{Poisson Regression (count).}
#'  \item {\code{"poisson-nloglik"}}{Negative Log Likelihood (Poisson Regression).}
#'  \item {\code{"reg:gamma"}}{Gamma Regression with Log-link.}
#'  \item {\code{"gamma-nloglik"}}{Negative Log Likelihood (Gamma Regression).}
#'  \item {\code{"gamma-deviance"}}{Residual Deviance (Gamma Regression).}
#'  \item {\code{"reg:tweedie"}}{Tweedie Regression with Log-link.}
#'  \item {\code{"tweedie-nloglik"}}{Negative Log Likelihood (Tweedie Regression).}
#' }
#' @param maximize Type: logical. Whether to maximize the metric, defaults to \code{NULL}.
#' @param metric Type: character or function. The metric to print against the \code{watchlist}, defaults to \code{rmse}. \itemize{
#'  \item {\code{"rmse"}}{Root Mean Squared Error.}
#'  \item {\code{"mae"}}{Mean Absolute Error.}
#'  \item {\code{"logloss"}}{Negative Log Likelihood.}
#'  \item {\code{"error"}}{Binary classification Error Rate.}
#'  \item {\code{"error@t"}}{Binary classification Error Rate at \code{t}.}
#'  \item {\code{"merror"}}{Multiclass classification Error Rate.}
#'  \item {\code{"mlogloss"}}{Multiclass Negative Log Likelihood.}
#'  \item {\code{"auc"}}{Area Under the Curve.}
#'  \item {\code{"ndcg@n"}}{Normalized Discounted Cumulative Gain at \code{n}.}
#'  \item {\code{"map@n"}}{Mean Average Precision at \code{n}.}
#' }
#' @param boost_method Type: character. Boosting method, defauts to \code{"gbtree"}. \itemize{
#'  \item Boosting Method.
#'  \item xgboost has access to three different boosting methods: \itemize{
#'  \item {\code{"gblinear"}}{Generalized Linear Model, which is using Shotgun (Parallel Stochastic Gradient Descent).}
#'  \item {\code{"gbtree"}}{Gradient Boosted Trees, which is the default boosting method using Decision Trees and Stochastic Gradient Descent.}
#'  \item {\code{"dart"}}{Dropout Additive Regression Trees, which is a method employing the Dropout method from Neural Networks.}
#'  }
#'  \item The booster method has a huge impact on training performance.
#'  \item The booster method defines the algorithm you will use for boosting or training the model.
#'  \item For instance, a linear boosted model is obviously better for linear problems.
#'  \item Tree-based boosted models are better for non-linear problems, as they have the ability to approximate them.
#'  \item DART (Dropout Additive Regression Trees) is similar to Dropout in neural networks, except you are applying this idea to trees (dropping trees randomly).
#' }
#' @param boost_tree Type: character. Tree method, defauts to \code{"hist"}. \itemize{
#'  \item Tree Method.
#'  \item Tips: leave it alone unless you know what you are doing.
#'  \item This parameter is exclusive to xgboost implementation and three different values: \itemize{
#'  \item {\code{"exact"}}{for training the exact original xgboost.}
#'  \item {\code{"approx"}}{for training the approximate/distributed xgboost.}
#'  \item {\code{"hist"}}{for training xgboost in fast histogram mode, similarly to LightGBM.}
#'  }
#'  \item The tree method has a huge impact on training speed.
#'  \item The way trees are built is essential to maximize or lower performance for training.
#'  \item In addition, it has a huge impact on the training speed, as leaving feature accuracy down for lower passes during training loops allow to train models significantly faster.
#' }
#' @param boost_grow Type: character. Growing method, defauts to \code{"depthwise"}. \itemize{
#'  \item Growing Method.
#'  \item Tips: leave it alone unless you know what you are doing.
#'  \item The original xgboost uses depthwise growing policy, which unallows growing deeper trees as long as all the nodes are not at the same level.
#'  \item The depthwise policy (\code{grow_policy = "depthwise"}) acts as a regularizer which lowers the fitting performance, by providing a potentially higher generalization performance.
#'  \item To act as the same as LightGBM (growing at the best loss instead of at the best depth), set \code{grow_policy = "lossguide"}.
#'  \item The tree growing method allows to switch between two ways of training: \itemize{
#'  \item depth-wise method: original xgboost training way, which is highly performing on datasets not relying on distribution rules (far from synthetic).
#'  \item loss-guide method: original LightGBM training way, which is highly performing on datasets relying on distribution rules (close to synthetic).
#'  }
#'  \item The xgboost way of training allows to minimize depth, where growing an additional depth is considered as a last resort.
#'  \item The LightGBM way of training allows to minimize loss, where growing an additional depth is not considered as a last resort.
#' }
#' @param boost_bin Type: numeric. Maximum number of unique values per feature, defauts to \code{255}. \itemize{
#'  \item Number of maximum unique values per feature.
#'  \item Tips: leave it alone unless you know what you are doing.
#'  \item xgboost does not optimize the dataset storage depending on the max_bin parameter.
#'  \item As such, it requires 4GB RAM to train a model on Higgs 3.5M.
#'  \item By providing less unique values per feature, the model can be trained significantly faster without a large loss in performance.
#'  \item In cases where the dataset is closer to a synthetic dataset, the model might perform even better than without binning.
#' }
#' @param boost_memory Type: character. Memory used for binning, defauts to \code{"uint32"}. \itemize{
#'  \item Memory pressure of bins.
#'  \item Tips: leave it alone unless you know what you are doing.
#'  \item The positive label should be the rare label.
#'  \item By performing a weight multiplication on the positive label, the model is performing a cost-sensitive training.
#'  \item The cost-sensitive training is applied to the booster model which impacts directly the trained models.
#'  \item It implies a potential higher performance, especially when it comes to ranking tasks such as for AUC.
#' }
#' @param boost_weighting Type: numeric. Weighting of positive labels, defauts to \code{1}. \itemize{
#'  \item Multiplication applied to every positive label weight.
#'  \item Tips: leave it alone unless you know what you are doing.
#'  \item The matrix data type is defining the memory pressure in memory, while determining also the maximum number of bins.
#'  \item The default binning is 32 bit, which means 255 bins are possible per column.
#'  \item Lowering it to 16 bit (127 bins) or 8 bit (63 bins) lowers the maximum number of bins, therefore lowering accuracy and improving memory pressure.
#' }
#' @param learn_threads Type: numeric. Number of threads, defauts to \code{1}. \itemize{
#'  \item Number of threads using for training models.
#'  \item Tips: larger data benefit from more threads, but smaller data has reverse benefits.
#'  \item Intel CPUs benefit from hyperthreading and you should use the number of logical cores in your computer instead of the number of physical cores.
#'  \item The old rationale "number of threads = physical cores" was when multithreading was so poor that the overhead was too large. Nowadays, this is not true for most cases (you would not multithread anymore if this were true).
#'  \item Using multithreaded training allows to train models faster.
#'  \item This is not always true in the case of small datasets, where training is so fast that the overhead is too large.
#'  \item In addition, when using many threads (like 40 on 1Mx1K dataset), be careful of the number of leaves parameter combined with unlimited depth, as it will massively slow down the training.
#'  \item To find the best number of threads, you can benchmark manually the training speed by changing the number of threads.
#'  \item Choosing the number of threads depends both on your CPU and the dataset. Do not overallocate logical cores.
#' }
#' @param learn_shrink Type: numeric. Learning rate, defauts to \code{0.05}. \itemize{
#'  \item Multiplication performed on each boosting iteration.
#'  \item Tips: set this larger for hyperparameter tuning.
#'  \item Once your learning rate is fixed, do not change it.
#'  \item It is not a good practice to consider the learning rate as a hyperparameter to tune.
#'  \item Learning rate should be tuned according to your training speed and performance tradeoff.
#'  \item Do not let an optimizer tune it. One must not expect to see an overfitting learning rate of 0.0202048.
#'  \item Each iteration is supposed to provide an improvement to the training loss.
#'  \item Such improvement is multiplied with the learning rate in order to perform smaller updates.
#'  \item Smaller updates allow to overfit slower the data, but requires more iterations for training.
#'  \item For instance, doing 5 iteations at a learning rate of 0.1 approximately would require doing 5000 iterations at a learning rate of 0.001, which might be obnoxious for large datasets.
#'  \item Typically, we use a learning rate of 0.05 or lower for training, while a learning rate of 0.10 or larger is used for tinkering the hyperparameters.
#' }
#' @param iteration_max Type: numeric. Number of boosting iterations, defauls to \code{100}. \itemize{
#'  \item Number of boosting iterations.
#'  \item Tips: combine with early stopping to stop automatically boosting.
#'  \item Larger is not always better.
#'  \item Keep an eye on overfitting.
#'  \item It is better to perform cross-validation one model at a time, in order to get the number of iterations per fold. In addition, this allows to get a precise idea of how noisy the data is.
#'  \item When selecting the number of iterations, it is typical to select 1.10x the mean of the number of iterations found via cross-validation.
#' }
#' @param iteration_trees Type: numeric. Averaged trees per iteration, defauls to \code{1}. \itemize{
#'  \item Number of trees per boosting iteration.
#'  \item Tips: Do not tune it unless you know what you are doing.
#'  \item To achieve Random Forest, one should use sampling parameters to not get identical trees.
#'  \item The combination of Random Forest and Gradient Boosting is well-known "not so good" combination.
#'  \item In fact, Gradient Boosted Trees is supposed to be an extension of Decision Trees and Random Forest, using mathematical optimization.
#'  \item Therefore, it does not make practical sense to use Gradient Boosted Random Forests.
#'  \item To achieve a similar performance to Random Forests, one should use a row sampling of 0.632 (.632 Bootstrap) and a column sampling depending on the task.
#'  \item For regression, it is recommended to use 1/3 features per tree.
#'  \item For classification, it is recommended to use sqrt(number of features)/(number of features) features per tree.
#'  \item For other cases, no recommendations are existing.
#' }
#' @param iteration_stop Type: numeric. Number of iterations without improvement before stopping, defauls to \code{20}. \itemize{
#'  \item Number of maximum iterations without improvements.
#'  \item Tips: make sure you added a validation dataset to watch, otherwise this parameter is useless.
#'  \item Setting early stopping too large risks overfitting by unallowing training to stop due to luck.
#'  \item Scale this parameter appropriately with the learning rate (usually: linearly).
#'  \item Early Stopping allows to not let a model train until the end when the validation metric is not improving for a specified amount of iterations.
#'  \item By keeping this value low enough, boosting will quickly give up training when there is no improvement over time.
#'  \item When it is large enough, boosting will refuse to give up training, even though some improvements over the best iteration might be pure luck.
#'  \item This value should be called accordingly with the number of iterations.
#' }
#' @param tree_depth Type: numeric. Maximum tree depth, defauls to \code{6}. \itemize{
#'  \item Maximum depth of each trained tree.
#'  \item Tips: use unlimited depth when needing deep branched trees.
#'  \item Unlimited depth is essential for training models whose branching is one-sided (instead of balanced branching). such as for long chain of features, like 50 to get to the expected real rule.
#'  \item Each model trained at each iteration will have that maximum depth and cannot bypass it.
#'  \item As the maximum depth increases, the model is able to fit better the training data.
#'  \item However, fitting better the training data does not cause 100% generalization to the validation data.
#'  \item In addition, this is the most sensible hyperparameter for gradient boosting: tune this first.
#'  \item xgboost lossguide training allows 0 depth training (unlimited depth).
#'  \item The maximum leaves allowed, if depth is not unlimited, is equal to 2^depth - 1 (ex: a maximum depth of 10 leads to a maximum of 1023 leaves)
#' }
#' @param tree_leaves Type: numeric. Maximum tree leaves, defauls to \code{0}. \itemize{
#'  \item Maximum leaves for each trained tree.
#'  \item Tips: adjust depth accordingly by allowing a slightly higher depth than the theoretical number of leaves.
#'  \item Restricting the number of leaves acts as a regularization in order to not grow very deep trees.
#'  \item It also prevents from growing gigantic trees when the maximum depth is large (if not unlimited).
#'  \item Each model trained at each iteration will have that maximum leaves and cannot bypass it.
#'  \item As the maximum leaves increases, the model is able to fit better the training data.
#'  \item However, fitting better the training data does not cause 100% generalization to the validation data.
#'  \item In addition, this is the second most sensible hyperparameter for gradient boosting: tune it with the maximum depth.
#' }
#' @param sample_row Type: numeric. Row sampling, defauls to \code{1}. \itemize{
#'  \item Percentage of rows used per iteration frequency.
#'  \item Tips: adjust it roughly but not precisely.
#'  \item Stochastic Gradient Descent is not always better than Gradient Descent.
#'  \item The name "Stochastic Gradient Descent" is technically both right and wrong.
#'  \item Each model trained at each iteration will have only a specific % subset of observations requested using subsample.
#'  \item By training over random partitions of the data, abusing the stochastic nature of the process, the resulting model might fit better the data.
#'  \item In addition, this is the third most sensible hyperparameter for gradient boosting: tune it with the column sampling.
#'  \item Overfitting happens when a combination of seed and very peculiar sampling value (like 0.728472) is used, as it does not make sense.
#' }
#' @param sample_col Type: numeric. Column sampling per tree, defauls to \code{1}. \itemize{
#'  \item Percentage of columns used per iteration.
#'  \item Tips: adjust it roughly but not precisely.
#'  \item Stochastic Gradient Descent is not always better than Gradient Descent.
#'  \item The name "Stochastic Gradient Descent" is technically both right and wrong.
#'  \item Each model trained at each iteration will have only a specific % subset of features requested using subsample.
#'  \item By training over random partitions of the data, abusing the stochastic nature of the process, the resulting model might fit better the data.
#'  \item In addition, this is the third most sensible hyperparameter for gradient boosting: tune it with the row sampling.
#'  \item Overfitting happens when a combination of seed and very peculiar sampling value (like 0.728472) is used, as it does not make sense.
#' }
#' @param reg_l1 Type: numeric. L1 regularization, defauls to \code{0}. \itemize{
#'  \item L1 Regularization for boosting.
#'  \item Tips: leave it alone unless you know what you are doing.
#'  \item Adding regularization is not always better.
#'  \item The regularization scaling is dataset-dependent and weight-dependent.
#'  \item Gradient Boosting applies regularization to the nominator of the gain computation.
#'  \item In addition, it is added to the numerator multiplicated by the weight of the sample.
#'  \item Each sample has its own pair of gradient/hessian, unlike typical gradient descent methods where that statistic pair is summed up for immediate output and parameter adjustment.
#' }
#' @param reg_l2 Type: numeric. L2 regularization, defauls to \code{0}. \itemize{
#'  \item L2 Regularization for boosting.
#'  \item Tips: leave it alone unless you know what you are doing.
#'  \item Adding regularization is not always better.
#'  \item The regularization scaling is dataset-dependent and weight-dependent.
#'  \item Gradient Boosting applies regularization to the nominator of the gain computation.
#'  \item In addition, it is added to the numerator multiplicated by the weight of the sample.
#'  \item Each sample has its own pair of gradient/hessian, unlike typical gradient descent methods where that statistic pair is summed up for immediate output and parameter adjustment.
#' }
#' @param reg_l2_bias Type: numeric. L2 Bias regularization (not for GBDT models), defauls to \code{0}. \itemize{
#'  \item L2 Bias Regularization for boosting.
#'  \item Tips: leave it alone unless you know what you are doing.
#'  \item Adding regularization is not always better.
#'  \item The regularization scaling is dataset-dependent and weight-dependent.
#'  \item Gradient Boosting applies regularization to the nominator of the gain computation.
#'  \item In addition, it is added to the numerator multiplicated by the weight of the sample.
#'  \item Each sample has its own pair of gradient/hessian, unlike typical gradient descent methods where that statistic pair is summed up for immediate output and parameter adjustment.
#' }
#' @param reg_loss Type: numeric. Minimum Loss per Split, defauls to \code{0}. \itemize{
#'  \item Prune by minimum loss requirement.
#'  \item Tips: leave it alone unless you know what you are doing.
#'  \item Adding pruning threshold is not always better.
#'  \item Gamma (loss) regularization happens post training (blocks the trees from being kept) unlike Hessian regularization.
#'  \item Loss regularization is a direct regularization technique allowing the model to prune any leaves which do not meet the minimal gain to split criteria.
#'  \item This is extremely useful when you are trying to build deep trees but trying also to avoid building useless branches of the trees (overfitting).
#' }
#' @param reg_hessian Type: numeric. Minimum Hessian per Split, defauls to \code{1}. \itemize{
#'  \item Prune by minimum hessian requirement.
#'  \item Tips: leave it alone unless you know what you are doing.
#'  \item Adding pruning threshold is not always better.
#'  \item Hessian regularization happens on the fly (blocks the trees for growing) unlike Loss regularization.
#' }
#' @param dart_rate_drop Type: numeric. DART booster tree drop rate, defauls to \code{0}. \itemize{
#'  \item Probability to to drop a tree on one iteration.
#'  \item Tips: leave it alone unless you know what you are doing.
#'  \item Smaller/Larger is not always better.
#'  \item Defines the dropping probability of each tree during each DART iteration to regenerate gradient/hessian statistics.
#' }
#' @param dart_skip_drop Type: numeric. DART booster tree skip rate, defauls to \code{0}. \itemize{
#'  \item Probability to to skipping any drop on one iteration.
#'  \item Tips: leave it alone unless you know what you are doing.
#'  \item Smaller/Larger is not always better.
#'  \item Defines the probability of skipping dropping during each DART iteration to regenerate gradient/hessian statistics.
#' }
#' @param dart_sampling Type: character. DART booster sampling distribution, defauls to \code{"uniform"}. Other choice is \code{"weighted"}. \itemize{
#'  \item Uniform weight application for trees.
#'  \item Tips: leave it alone unless you know what you are doing.
#'  \item Use \code{sample_type = "uniform"} to setup uniform sampling for dropped trees.
#'  \item You may use also \code{sample_type = "weighted"} to drop trees in proportion to their weights, defined by normalize_type.
#'  \item Smaller/Larger is not always better.
#'  \item Defines the probability of skipping dropping during each DART iteration to regenerate gradient/hessian statistics.
#' }
#' @param dart_norm Type: character. DART booster weight normalization, defauls to \code{"tree"}. Other choice is \code{"forest"}. \itemize{
#'  \item Weight normalization method for trees.
#'  \item Tips: leave it alone unless you know what you are doing.
#'  \item Smaller/Larger is not always better.
#'  \item Normalizing the weight of trees differently allows to put an emphasis on the earliest/latest trees built, leading to different tree structures.
#' }
#' @param dart_min_1 Type: numeric. DART booster drop at least one tree, defauls to \code{0}. Other choice is \code{1}. \itemize{
#'  \item Minimum of one dropped tree at any iteration.
#'  \item Tips: leave it alone unless you know what you are doing.
#'  \item Smaller/Larger is not always better.
#'  \item Dropping at least one tree at each iteration allows to build different trees.
#' }
#' @param ... Other parameters to pass to xgboost's \code{params}.
#' 
#' @return The xgboost model.
#' 
#' @examples
#' library(Matrix)
#' library(xgboost)
#' 
#' data(agaricus.train, package = "xgboost")
#' data(agaricus.test, package = "xgboost")
#' 
#' dtrain <- xgb.DMatrix(agaricus.train$data, label = agaricus.train$label)
#' dtest <- xgb.DMatrix(agaricus.test$data, label = agaricus.test$label)
#' watchlist <- list(train = dtrain, eval = dtest)
#' 
#' logregobj <- function(preds, dtrain) {
#'   labels <- getinfo(dtrain, "label")
#'   preds <- 1/(1 + exp(-preds))
#'   grad <- preds - labels
#'   hess <- preds * (1 - preds)
#'   return(list(grad = grad, hess = hess))
#' }
#' evalerror <- function(preds, dtrain) {
#'   labels <- getinfo(dtrain, "label")
#'   err <- as.numeric(sum(labels != (preds > 0)))/length(labels)
#'   return(list(metric = "error", value = err))
#' }
#' 
#' model <- Laurae.xgb.train(train = dtrain,
#'                           watchlist = watchlist,
#'                           verbose = 1,
#'                           objective = "binary:logistic",
#'                           metric = "auc",
#'                           tree_depth = 2,
#'                           learn_shrink = 1,
#'                           learn_threads = 1,
#'                           iteration_max = 5)
#' 
#' model <- Laurae.xgb.train(train = dtrain,
#'                           watchlist = watchlist,
#'                           verbose = 1,
#'                           objective = logregobj,
#'                           metric = "auc",
#'                           tree_depth = 2,
#'                           learn_shrink = 1,
#'                           learn_threads = 1,
#'                           iteration_max = 5)
#' 
#' model <- Laurae.xgb.train(train = dtrain,
#'                           watchlist = watchlist,
#'                           verbose = 1,
#'                           objective = "binary:logistic",
#'                           metric = evalerror,
#'                           tree_depth = 2,
#'                           learn_shrink = 1,
#'                           learn_threads = 1,
#'                           iteration_max = 5,
#'                           maximize = FALSE)
#' 
#' # CAN'T DO THIS, IGNORE ANY NOT 1st METRIC
#' model <- Laurae.xgb.train(train = dtrain,
#'                           watchlist = watchlist,
#'                           verbose = 1,
#'                           objective = logregobj,
#'                           metric = c("rmse", "auc"),
#'                           tree_depth = 2,
#'                           learn_shrink = 1,
#'                           learn_threads = 1,
#'                           iteration_max = 5)
#' 
#' model <- Laurae.xgb.train(train = dtrain,
#'                           watchlist = watchlist,
#'                           verbose = 1,
#'                           objective = logregobj,
#'                           metric = evalerror,
#'                           tree_depth = 2,
#'                           learn_shrink = 1,
#'                           learn_threads = 1,
#'                           iteration_max = 5,
#'                           maximize = FALSE)
#' 
#' # CAN'T DO THIS
#' # model <- Laurae.xgb.train(train = dtrain,
#' #                           watchlist = watchlist,
#' #                           verbose = 1,
#' #                           objective = logregobj,
#' #                           metric = c(evalerror, "auc"),
#' #                           tree_depth = 2,
#' #                           learn_shrink = 1,
#' #                           learn_threads = 1,
#' #                           iteration_max = 5,
#' #                           maximize = FALSE)
#' 
#' @export


Laurae.xgb.train <- function(train,
                             watchlist = NULL,
                             clean_mem = FALSE,
                             seed = 1,
                             verbose = 1,
                             verbose_iterations = 1,
                             objective = "reg:linear",
                             metric = "rmse",
                             maximize = NULL,
                             boost_method = "gbtree",
                             boost_tree = "hist",
                             boost_grow = "depthwise",
                             boost_bin = 255,
                             boost_memory = "uint32",
                             boost_weighting = 1,
                             learn_threads = 1,
                             learn_shrink = 0.05,
                             iteration_max = 100,
                             iteration_trees = 1,
                             iteration_stop = 20,
                             tree_depth = 6,
                             tree_leaves = 0,
                             sample_row = 1,
                             sample_col = 1,
                             reg_l1 = 0,
                             reg_l2 = 0,
                             reg_l2_bias = 0,
                             reg_loss = 0,
                             reg_hessian = 1,
                             dart_rate_drop = 0,
                             dart_skip_drop = 0,
                             dart_sampling = "uniform",
                             dart_norm = "tree",
                             dart_min_1 = 0,
                             ...) {
  
  if (clean_mem) {gc(verbose = FALSE)}
  
  if (length(metric) == 1) {
    if (is.function(metric)) {
      metrics1 <- NULL
      metrics2 <- metric
    } else {
      metrics1 <- metric
      metrics2 <- NULL
    }
  } else if (length(metric) > 1) {
    is_fun <- unlist(lapply(metric, function(x) {is.function(x)}))
    metrics1 <- metric[!is_fun]
    metrics2 <- metric[is_fun]
    if (length(metrics1) == 0) {
      metrics1 <- NULL
    } else if (length(metrics2) == 0) {
      metrics2 <- NULL
    }
  } else {
    metrics1 <- NULL
    metrics2 <- NULL
  }
  
  set.seed(seed)
  model <- xgboost::xgb.train(params = Filter(Negate(is.null), list(booster = boost_method,
                                                                    tree_method = boost_tree,
                                                                    grow_policy = boost_grow,
                                                                    max_bin = boost_bin,
                                                                    colmat_dtype = boost_memory,
                                                                    scale_pos_weight = boost_weighting,
                                                                    nthread = learn_threads,
                                                                    eta = learn_shrink,
                                                                    objective = switch((!is.function(objective)) + 1, NULL, objective),
                                                                    eval_metric = metrics1,
                                                                    max_depth = tree_depth,
                                                                    max_leaves = tree_leaves,
                                                                    subsample = sample_row,
                                                                    colsample_bytree = sample_col,
                                                                    alpha = reg_l1,
                                                                    lambda = reg_l2,
                                                                    lambda_bias = reg_l2_bias,
                                                                    gamma = reg_loss,
                                                                    min_child_weight = reg_hessian,
                                                                    rate_drop = dart_rate_drop,
                                                                    skip_drop = dart_skip_drop,
                                                                    sample_type = dart_sampling,
                                                                    normalize_type = dart_norm,
                                                                    one_drop = dart_min_1,
                                                                    ...)),
                              data = train,
                              nrounds = iteration_max,
                              num_parallel_tree = iteration_trees,
                              watchlist = watchlist,
                              obj = switch((is.function(objective)) + 1, NULL, objective),
                              feval = metrics2,
                              early_stopping_rounds = iteration_stop,
                              verbose = verbose,
                              print_every_n = verbose_iterations,
                              maximize = switch((!is.null(maximize)) + 1, NULL, maximize))
  
  if (clean_mem) {gc(verbose = FALSE)}
  
  return(model)
  
}
