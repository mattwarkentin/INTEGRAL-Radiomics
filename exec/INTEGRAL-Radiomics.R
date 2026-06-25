#!/usr/bin/env Rapp
#| description: >
#|  An implementation of the INTEGRAL-Radiomics pulmonary nodule
#|  malignancy prediction model. The package enables standardized preprocessing,
#|  radiomics feature extraction, and malignancy risk prediction for pulmonary
#|  nodules detected on computed tomography (CT) imaging. It is designed to
#|  support reproducible research for radiomics-based lung cancer risk
#|  assessment workflows. The INTEGRAL-Radiomics model is described in Warkentin
#|  et al. (2024) <doi:10.1136/thorax-2023-220226> (PMID: 38195644).
#| launcher:
#|   name: integral-radiomics

#| description: Print integralrad version and exit.
version <- FALSE

if (version) {
  cat(format(utils::packageVersion("integralrad")), "\n")
  quit(status = 0)
}

#| description: Path to input CSV.
#| short: 'i'
#| val_type: string
#| required: true
#| negative_alias: false
input <- NA

#| description: Path to save output CSV.
#| short: 'o'
#| val_type: string
#| required: true
#| negative_alias: false
output <- NA

#| description: Suppress messages and progress bars.
#| short: 'q'
#| negative_alias: false
quiet <- FALSE

default_error <- function(e) {
  msg <- conditionMessage(e)
  msg <- cli::ansi_strip(msg)
  cat(msg, "\n", file = stderr())
  quit(status = 1)
}

if (rlang::is_na(input)) {
  rlang::inform(
    message = "`--input` is required but missing."
  )
  quit(status = 1)
}

if (rlang::is_na(output)) {
  rlang::inform(
    message = "`--output` is required but missing."
  )
  quit(status = 1)
}

tryCatch(
  {
    df_pred <- integralrad::predict_integral_radiomics(input, quiet)
    readr::write_csv(df_pred, output)
  },
  error = default_error
)
