#' Install `integralrad` cli applications.
#'
#' @inheritDotParams Rapp::install_pkg_cli_apps -package -lib.loc
#' @export
install_integralrad_cli <- function(...) {
  Rapp::install_pkg_cli_apps(package = "integralrad", lib.loc = NULL, ...)
}
