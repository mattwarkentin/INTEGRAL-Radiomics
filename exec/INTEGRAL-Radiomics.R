#!/usr/bin/env Rapp
#| description: Predict nodule malignancy risk using the INTEGRAL-Radiomics model (https://thorax.bmj.com/content/early/2024/01/08/thorax-2023-220226).
#| launcher:
#|   name: integral-radiomics
#|   vanilla: true

#| description: Path to input CSV.
#| val_type: string
#| required: true
#| negative_alias: false
input <- NA

#| description: Path to save output CSV.
#| val_type: string
#| required: true
#| negative_alias: false
output <- NA

df_pred <- integralrad::predict_integral_radiomics(input)

readr::write_csv(df_pred, output)
