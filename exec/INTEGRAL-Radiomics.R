#!/usr/bin/env Rapp
#| description: Predict nodule malignancy risk using the INTEGRAL-Radiomics model (https://thorax.bmj.com/content/early/2024/01/08/thorax-2023-220226).
#| launcher:
#|   name: integral-radiomics
#|   vanilla: true

library(vetiver)
library(glmnet)
library(parsnip)
library(workflows)
library(recipes)

#| description: Path to image.
#| val_type: string
#| required: true
image <- NA

#| description: Path to mask.
#| val_type: string
#| required: true
mask <- NA

#| description: Age (years)
#| val_type: integer
#| required: true
age <- NA

#| description: Sex (0=Male, 1=Female)
#| val_type: integer
#| required: true
sex <- NA

#| description: Family history of lung cancer (0=No, 1=Yes)
#| val_type: integer
#| required: true
fhlc <- NA

#| description: History of COPD or emphysema (0=No, 1=Yes)
#| val_type: integer
#| required: true
copdemph <- NA

#| description: Former smoker status (0=No, 1=Yes)
#| val_type: integer
#| required: true
formersmk <- NA

#| description: Number of years smoked cigarettes
#| val_type: integer
#| required: true
duration <- NA

#| description: Cigarettes per day
#| val_type: integer
#| required: true
cigday <- NA

#| description: ears since quitting for former smokers (Set to 0 for current smokers)
#| val_type: integer
#| required: true
quittime <- NA

#| description: Body mass index (kg/m^2)
#| val_type: float
#| required: true
bmi <- NA

#| description: Output CSV
#| val_type: string
#| required: false
out <- NA

#| description: Output PyRadiomics Features (CSV)
#| val_type: string
#| required: false
feats <- NA

check_integer_range <- function(x, rng, nm) {
  if (rlang::is_scalar_integerish(x) & x >= rng[1] & x <= rng[2]) {
    return(x)
  }
  rlang::abort(
    message = glue::glue(
      "`{nm}` must be an integer between {rng[1]} and {rng[2]}."
    )
  )
}

check_integer_level <- function(x, rng, nm) {
  if (rlang::is_scalar_integerish(x) & x %in% rng) {
    return(x)
  }
  rlang::abort(
    message = glue::glue(
      "`{nm}` must be an integer ({glue::glue_collapse(rng, sep = ',')})}."
    )
  )
}

check_numeric_range <- function(x, rng, nm) {
  if (rlang::is_scalar_double(x) & x >= rng[1] & x <= rng[2]) {
    return(x)
  }
  rlang::abort(
    message = glue::glue(
      "`{nm}` must be a float between {rng[1]} and {rng[2]}."
    )
  )
}

check_file_exist <- function(x) {
  if (fs::file_exists(x)) {
    return(x)
  }
  rlang::abort(
    message = glue::glue("{x} does not exist.")
  )
}

age <- check_integer_range(age, c(0, 100), "age")
female <- check_integer_level(sex, c(0, 1), "sex")
fhlc <- check_integer_level(fhlc, c(0, 1), "fhlc")
copdemph <- check_integer_level(copdemph, c(0, 1), "copdemph")
formersmk <- check_integer_level(formersmk, c(0, 1), "formersmk")
duration <- check_integer_range(duration, c(0, age), "duration")
cigday <- check_integer_range(cigday, c(0, 100), "cigday")
quittime <- check_integer_range(quittime, c(0, age), "quittime")
bmi <- check_numeric_range(bmi, c(15, 50), "bmi")

epi_df <- data.frame(
  study = "",
  pid = "",
  nid = 1L,
  epi_age = age,
  epi_female = female,
  epi_fhlc = fhlc,
  epi_copdemph = copdemph,
  epi_formersmk = formersmk,
  epi_duration = duration,
  epi_cigday = cigday,
  epi_quittime = quittime,
  epi_bmi = bmi
)

## 1. PyRadiomics feature extraction
temp_csv <- tempfile(fileext = ".csv")
config_file <- system.file("PyRadiomics_config.yaml", package = "integralrad")

sys::exec_wait(
  cmd = "pyradiomics",
  c(
    check_file_exist(image),
    check_file_exist(mask),
    glue::glue("--out={temp_csv}"),
    glue::glue("--param={config_file}"),
    "--format=csv"
  )
)

## 2. Combine data
eng_feats <- readr::read_csv(temp_csv)

if (!rlang::is_na(feats)) {
  readr::write_csv(eng_feats, feats)
}

clean_eng_feats <-
  eng_feats |>
  dplyr::rename_with(\(x) stringr::str_replace_all(x, "\\.", "-"))

combined_df <- dplyr::bind_cols(epi_df, clean_eng_feats)

## 3. Make predictions
integral_rad <- readRDS(system.file(
  "INTEGRAL-Radiomics.rds",
  package = "integralrad"
))

pred <- stats::predict(integral_rad, new_data = combined_df, type = "prob")

if (!rlang::is_na(out)) {
  df_out <- dplyr::bind_cols(image = image, mask = mask, epi_df[, 4:12], pred)
  readr::write_csv(df_out, out)
} else {
  cat(pred$.pred_1)
}
