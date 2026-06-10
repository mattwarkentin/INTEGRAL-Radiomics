#' INTEGRAL-Radiomics Nodule Malignancy Predictions
#'
#' @description
#' Predict the probability of nodule malignancy using the INTEGRAL-Radiomics
#'   model. The model uses the Python library `PyRadiomics` to perform feature
#'   extraction before making model predictions.
#'
#' @param input Path to a CSV. See Details.
#'
#' @details
#' The input for this function should be a path to aCSV with the following
#'   columns (names must be exact matches):
#'   - `image`: Path to image (NRRD format)
#'   - `mask`: Path to nodule mask (NRRD format)
#'   - `age`: Age (years)
#'   - `sex`: Sex (0=Male, 1=Female)
#'   - `bmi`: Body mass index (kg/m^2)
#'   - `fhlc`: Family history of lung cancer (0=No, 1=Yes)
#'   - `copdemph`: History of COPD or emphysema (0=No, 1=Yes)
#'   - `formersmk`: Former smoker status (0=No, 1=Yes)
#'   - `duration`: Number of years smoked
#'   - `cigday`: Average number of cigarettes smoked per day
#'   - `quittime`: Years since quitting for former smokers (set to 0 for current
#'     smokers)
#'
#' @return A `tibble::tibble` with the input columsn and one column added for
#'   the probability of nodule malignancy (i.e., lung cancer).
#'
#' @import glmnet parsnip recipes workflows vetiver readr
#'
#' @export
predict_integral_radiomics <- function(input) {
  df <- process_input_csv(input)

  feats <-
    purrr::map2(df$image, df$mask, extract_radiomics) |>
    purrr::list_rbind()

  pred_df <- dplyr::bind_cols(df, feats)

  model <- readRDS(system.file(
    "INTEGRAL-Radiomics.rds",
    package = "integralrad"
  ))

  pred <- stats::predict(model, new_data = pred_df, type = "prob")

  dplyr::bind_cols(df, pred) |>
    dplyr::select(-c(study, pid, nid))
}

utils::globalVariables(c("study", "pid", "nid"))
