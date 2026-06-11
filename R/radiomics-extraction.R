#' PyRadiomics Feature Extraction
#'
#' @param image File path to input image.
#' @param mask File path to nodule mask.
#' @param quiet Logical. Set to `TRUE` to suppress messages. Default is `FALSE`.
#'
#' @export
extract_radiomics <- function(image, mask, quiet = FALSE) {
  params <- system.file("PyRadiomics_config.yaml", package = "integralrad")
  extractor <- radiomics$featureextractor$RadiomicsFeatureExtractor(params)

  logger <- logging$getLogger("radiomics.glcm")
  logger$setLevel(logging$ERROR)

  result <- extractor$execute(image, mask)

  names_to_remove <- stringr::str_detect(names(result), "^diagnostics_")
  results_tbl <- dplyr::as_tibble(result[!names_to_remove])
  results_tbl
}
