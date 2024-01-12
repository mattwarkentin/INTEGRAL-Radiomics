# INTEGRAL Radiomics

This repository contains the model and example code for using the radiomics pulmonary nodule malignancy model reported in:

> Warkentin MT, Al-Sawaihey H, Lam S, et al Radiomics analysis to predict pulmonary nodule malignancy using machine learning approaches _Thorax_ Published Online First: 09 January 2024. doi: 10.1136/thorax-2023-220226

## Usage

### Setup

To use this model, we assume you have performed feature extraction using the PyRadiomics Python library (<https://pyradiomics.readthedocs.io>). Note, that this study used PyRadiomics V.3.0.1. More information about the feature extraction can be found in the published manuscript cited below.

We provie the YAML configuration file (`PyRadiomics_config.yaml`) in this repository so that an identical feature extraction can be performed. See the PyRadiomics website for details on performing customized feature extractions (<https://pyradiomics.readthedocs.io>).

In addition to the 134 radiomics features retained in the final model, the following patient-level features are required:

- `epi_age`: Patients age (years)
- `epi_female`: Binary variable for sex (0=Male, 1=Female)
- `epi_fhlc`: Binary variable for family history of lung cancer (0=No, 1=Yes)
- `epi_copdemph`: Binary variable for history of COPD or emphysema (0=No, 1=Yes)
- `epi_formersmk`: Former smoker status (0=No, 1=Yes)
- `epi_duration` Number of years smoked cigarettes
- `epi_cigday`: Cigarettes per day
- `epi_bmi`: Body mass index (kg/m^2)

The data frame MUST also contain identifying variables for `study`, `pid` (patient ID), and `nid` (nodule ID), though these may be left empty and are not used in the prediction.

Note: The data should not be normalized prior to using the `predict()` function describe below. Normalization of predictors happens during the call to `predict()`.

### Model Predictions

Once feature extraction is complete the following code can be used to load and make predictions on your data frame (or tibble), assumed to be called `your_data`. 

```r
# install.packages(c('tidymodels', 'glmnet', 'vetiver'))
library(tidymodels)
library(glmnet)
library(vetiver)

# Load the INTEGRAL-Radiomics model
integral_rad <- readRDS('INTEGRAL-Radiomics.rds')

# Precict probabilities for `your_data`
predict(integral_rad, new_data = your_data, type = 'prob')
```

The `predict(...)` function will return two columns (`.pred_0` and `.pred_1`) that correspond to the probabilties of a pulmonary nodule being benign (`0`) or malignant (`1`). Users may wish to threshold these probabilities to obtain binary class labels.

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
