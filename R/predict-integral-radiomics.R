#' INTEGRAL-Radiomics Nodule Malignancy Prediction
#'
#' @description
#' Predict the probability of malignancy for a pulmonary nodule using the
#'   **INTEGRAL-Radiomics** model. This function uses the Python library
#'   [`PyRadiomics`](https://pyradiomics.readthedocs.io/en/latest/) to perform
#'   feature extraction before making model predictions.
#'
#' @param input Path to a CSV. See Details for more information on the format.
#' @param quiet Logical. Set to `TRUE` to suppress messages and progress bars.
#'   Default is `FALSE`.
#'
#' @details
#' The `input` for this function should be a path to a CSV with the following
#'   columns (column names must be exact matches):
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
#' @return A [`tibble::tibble`] with the `input` columns and two columns added
#'   for the probability of nodule malignancy (`pred_malignant`) and the
#'   complementary probability of being a benign nodule (`pred_benign`).
#'
#' @import glmnet parsnip recipes workflows vetiver readr
#'
#' @examples
#' \dontrun{
#' predict_integral_radiomics("input.csv")
#' }
#'
#' @export
predict_integral_radiomics <- function(input, quiet = FALSE) {
  df <- process_input_csv(input, quiet)

  feats <-
    purrr::map2(df$image, df$mask, extract_radiomics, .progress = !quiet) |>
    purrr::list_rbind()

  pred_df <- dplyr::bind_cols(df, feats)

  model <- readRDS(system.file(
    "INTEGRAL-Radiomics.rds",
    package = "integralrad"
  ))

  pred <- stats::predict(model, new_data = pred_df, type = "prob")

  dplyr::bind_cols(df, pred) |>
    dplyr::select(-c(study, pid, nid)) |>
    dplyr::rename_with(\(x) stringr::str_remove(x, "^epi_")) |>
    dplyr::rename(
      pred_benign = .pred_0,
      pred_malignant = .pred_1
    )
}

utils::globalVariables(c("study", "pid", "nid", ".pred_0", ".pred_1"))
