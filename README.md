# INTEGRAL Radiomics

This repository contains the model and example code for using the INTEGRAL-Radiomics screen-detected pulmonary nodule malignancy model reported in:

> Warkentin MT, Al-Sawaihey H, Lam S, et al Radiomics analysis to predict pulmonary nodule malignancy using machine learning approaches _Thorax_ Published Online First: 09 January 2024. doi: 10.1136/thorax-2023-220226

If you have any comments or questions, please file an [Issue](https://github.com/mattwarkentin/INTEGRAL-Radiomics/issues).

## Usage

### Command-Line Interface

As of May 2026, we have added a command-line interface to simplify getting predictions using the INTEGRAL-Radiomics model.

Within a project directory, create a Python virtual environment and install the required dependencies for PyRadiomics. Use the requirements.txt file found [here](https://raw.githubusercontent.com/mattwarkentin/INTEGRAL-Radiomics/refs/heads/main/inst/requirements.txt). 

For example, in the shell:

```sh
wget https://raw.githubusercontent.com/mattwarkentin/INTEGRAL-Radiomics/refs/heads/main/inst/requirements.txt
python3.11 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```

Next, we install `Rapp` to use the CLI:

```sh
# Install `Rapp`
Rscript -e "install.packages('Rapp')"

# Add `Rapp` to PATH
Rscript -e "Rapp::install_pkg_cli_apps('Rapp')"
```

Next, we install the `integralrad` R package from GitHub:

```r
# Install `integralrad`
Rscript -e "pak::pak('mattwarkentin/INTEGRAL-Radiomics')"

# Add `integral-radiomics` CLI to PATH
Rscript -e "integralrad::install_integralrad_cli()"
```

Finally, we can use the INTEGRAL-Radiomics CLI:

```sh
integral-radiomics \
  --image=<path-to-image> \
  --mask=<path-to-mask> \
  --age=65 \
  --sex=0 \
  --fhlc=1 \
  --copdemph=1 \
  --formersmk=0 \
  --duration=30 \
  --cigday=20 \
  --quittime=0 \
  --bmi=25 \
  --out=<output-csv>

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
