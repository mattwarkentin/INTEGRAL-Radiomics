#!/usr/bin/env Rapp
#| description: Predict nodule malignancy risk using the INTEGRAL-Radiomics model (https://thorax.bmj.com/content/early/2024/01/08/thorax-2023-220226).
#| launcher:
#|   name: integral-radiomics
#|   vanilla: true

#| description: Input CSV.
#| val_type: string
#| required: true
input <- NA

#| description: Output CSV
#| val_type: string
#| required: true
output <- NA

df_pred <- integralrad::predict_integral_radiomics(input)

readr::write_csv(df_pred, output)
