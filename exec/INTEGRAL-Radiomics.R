#!/usr/bin/env Rapp
#| launcher:
#|   name: integral-radiomics
#|   vanilla: true

#| description: Predict nodule malignancy risk using the INTEGRAL-Radiomics model (https://thorax.bmj.com/content/early/2024/01/08/thorax-2023-220226).

#| description: Path to image.
#| val_type: string
#| required: true
image <- NA

#| description: Path to mask.
#| val_type: string
mask <- NA

#| description: Age (years)
#| val_type: integer
age <- NA

#| description: Sex (0=Male, 1=Female)
#| val_type: integer
sex <- NA

#| description: Family history of lung cancer (0=No, 1=Yes)
#| val_type: integer
fhlc <- NA

#| description: History of COPD or emphysema (0=No, 1=Yes)
#| val_type: integer
copdemph <- NA

#| description: Former smoker status (0=No, 1=Yes)
#| val_type: integer
#| required: true
formersmk <- NA

#| description: Number of years smoked cigarettes
#| val_type: integer
duration <- NA

#| description: Cigarettes per day
#| val_type: integer
cigday <- NA

#| description: ears since quitting for former smokers (Set to 0 for current smokers)
#| val_type: integer
quittime <- NA

#| description: Body mass index (kg/m^2)
#| val_type: float
bmi <- NA

#| description: Output CSV
#| val_type: string
out <- NA

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

sys::exec_wait(
  cmd = "pyradiomics",
  c(
    check_file_exist(image),
    check_file_exist(mask),
    glue::glue("--out={temp_csv}"),
    glue::glue(
      '--param={system.file("PyRadiomics_config.yaml", "integralrad")}'
    ),
    "--format=csv"
  )
)

## 2. Combine data
eng_feats <- readr::read_csv(temp_csv)

clean_eng_feats <-
  eng_feats |>
  dplyr::rename_with(\(x) stringr::str_replace_all(x, "\\.", "-"))

combined_df <- dplyr::bind_cols(epi_df, clean_eng_feats)

## 3. Make predictions
integral_rad <- readRDS("INTEGRAL-Radiomics.rds")
pred <- predict(integral_rad, new_data = combined_df, type = "prob")
readr::write_csv(pred, out)
