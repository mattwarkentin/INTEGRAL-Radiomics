# INTEGRAL-Radiomics

<!-- badges: start -->
[![R-CMD-check](https://github.com/mattwarkentin/INTEGRAL-Radiomics/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/mattwarkentin/INTEGRAL-Radiomics/actions/workflows/R-CMD-check.yaml)
[![Lifecycle: experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
<!-- badges: end -->

This repository contains the model and code for using the **INTEGRAL-Radiomics** screen-detected pulmonary nodule malignancy model published in:

> Warkentin MT, Al-Sawaihey H, Lam S, et al Radiomics analysis to predict pulmonary nodule malignancy using machine learning approaches _Thorax_ Published Online First: 09 January 2024. doi: 10.1136/thorax-2023-220226

If you have any comments or questions, please file an [Issue](https://github.com/mattwarkentin/INTEGRAL-Radiomics/issues).

## Usage

To use the INTEGRAL-Radiomics model, you simply need to install the R package `integralrad` and it handles all the necessary R and Python dependencies to perform the PyRadiomics feature extraction and model predictions.

```r
# Install `integralrad`
pak::pak("mattwarkentin/integralrad")
```

Once installed, we can use `extract_radiomics(...)` to perform only the feature extraction, or `predict_integral_radiomics(...)` to execute the entire prediction pipeline. 

```r
library(integralrad)

# Path to CSV with required columns (see `?predict_integral_radiomics` for details)
input <- "path/to/csv"

preds <- predict_integral_radiomics(input)
```

### Command-Line Interface

We have also included a command-line interface to simplify getting predictions using the INTEGRAL-Radiomics model. For input, simply pass in a path to a CSV file (`--input`) that contains the relevant columns described in `?predict_integral_radiomics()`. You must also provide the path to where the output CSV should be saved on disk (`--output`).

After installing the package (as described above), you simply need to install the `integral-radiomics` CLI by running the following R code:

```r
integralrad::install_integralrad_cli()
```

After restarting your shell, you should be able to run the following:

```sh
integral-radiomics --input=<path-to-input> --output=<path-to-output>
```

## Citation

If you use this model, please cite the following article:

Warkentin MT, Al-Sawaihey H, Lam S, et al Radiomics analysis to predict pulmonary nodule malignancy using machine learning approaches _Thorax_ Published Online First: 09 January 2024. doi: 10.1136/thorax-2023-220226

```
@article {Warkentinthorax-2023-220226,
  author = {Matthew T Warkentin and Hamad Al-Sawaihey and Stephen Lam and Geoffrey Liu and Brenda Diergaarde and Jian-Min Yuan and David O Wilson and Sukhinder Atkar-Khattra and Benjamin Grant and Yonathan Brhane and Elham Khodayari-Moez and Kiera R Murison and Martin C Tammemagi and Kieran R Campbell and Rayjean J Hung},
  title = {Radiomics analysis to predict pulmonary nodule malignancy using machine learning approaches},
  elocation-id = {thorax-2023-220226},
  year = {2024},
  doi = {10.1136/thorax-2023-220226},
  publisher = {BMJ Publishing Group Ltd},
  issn = {0040-6376},
  URL = {https://thorax.bmj.com/content/early/2024/01/08/thorax-2023-220226},
  eprint = {https://thorax.bmj.com/content/early/2024/01/08/thorax-2023-220226.full.pdf},
  journal = {Thorax}
}
```
