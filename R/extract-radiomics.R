#' PyRadiomics Feature Extraction
#'
#' This function performs the radiomics feature extraction using the
#'   [`PyRadiomics`](https://pyradiomics.readthedocs.io/en/latest/) Python
#'   library. These 2,060 radiomic features are required by the
#'   **INTEGRAL-Radiomics** model. Configuration of the feature extraction is
#'   automatically handled by the configuration file shipped with this package.
#'   All Python dependencies are managed by [reticulate::py_require()]. This
#'   function is exported so users can get the radiomic features, if desired.
#'   However, most users will use [predict_integral_radiomics()] directly which
#'   calls this function internally.
#'
#' @param image File path to input image (NRRD format).
#' @param mask File path to nodule mask (NRRD format).
#'
#' @md
#'
#' @examples
#' \dontrun{
#' extract_radiomics("image.nrrd", "mask.nrrd")
#' }
#'
#' @export
extract_radiomics <- function(image, mask) {
  params <- system.file("PyRadiomics_config.yaml", package = "integralrad")
  extractor <- radiomics$featureextractor$RadiomicsFeatureExtractor(params)

  logger <- logging$getLogger("radiomics.glcm")
  logger$setLevel(logging$ERROR)

  result <- extractor$execute(image, mask)

  names_to_remove <- stringr::str_detect(names(result), "^diagnostics_")
  results_tbl <- dplyr::as_tibble(result[!names_to_remove])
  results_tbl
}
