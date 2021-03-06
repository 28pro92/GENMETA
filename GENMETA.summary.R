#' Summarizing Generalized Meta Analysis
#'
#' This function prints the summary of GENMETA results.
#' @param object an object of class "GENMETA"
#' @param signi_digits an optional numeric indicating the number of significant digits to be shown in the summary. Default is 3.
#' @examples
#' # This example shows how to obtain the summary of GENMETA object.
#' data(reference_data)
#' data(study_info)
#' model <- "logistic"
#' result_diff <- GENMETA(study_info, reference_data, model, variable_intercepts = TRUE)
#' GENMETA.summary(result_diff, signi_digits = 4)
#' result_same <- GENMETA(study_info, reference_data, model)
#' GENMETA.summary(result_same)
#' @export
# summary.GENMETA <-function(object, ...){
#   UseMethod("summary")
#   NextMethod("generic = NULL, object = NULL", ...)
# }
GENMETA.summary <- function(object, signi_digits = 3)
{
  x <- object
  GMeta_opt_estimate <- as.vector(x[[1]])
  GMeta_opt_std_error <- sqrt(as.vector(diag(x[[2]])))
  Var_opt_GMeta <- diag(GMeta_opt_std_error)
  z_stat_opt_GMeta <- GMeta_opt_estimate/GMeta_opt_std_error
  p_val_opt_GMeta <- 1 - pnorm(abs(z_stat_opt_GMeta))
  summary_data_frame_opt <- data.frame(cbind(GMeta_opt_estimate, GMeta_opt_std_error, z_stat_opt_GMeta, p_val_opt_GMeta))
  colnames(summary_data_frame_opt) <- c("Estimate", "Std.Error", "z value", "Pr(>|z|)")
  rownames(summary_data_frame_opt) <- names(x[[1]])
  summary_data_frame_opt <- signif(summary_data_frame_opt, signi_digits)
  signif_column <- factor(noquote(sapply(summary_data_frame_opt[, 4], sign.star)))
  summary_data_frame_opt <- cbind(summary_data_frame_opt, signif_column)
  colnames(summary_data_frame_opt)[5] <- paste0(' ')
  cat("Call:\n")
  print(x[[5]])
  cat("\n")
  cat("Coefficients: \n")
  print.data.frame(summary_data_frame_opt, print.gap = 2)
  cat("\n---\n")
  cat("Significant codes:\n")
  cat("0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1 \n")
  cat("\n")
  cat("Total number of iterations: ")
  cat(x[[4]])

}
