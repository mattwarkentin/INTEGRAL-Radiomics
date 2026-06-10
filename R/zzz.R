radiomics <- NULL

.onLoad <- function(libname, pkgname) {
  Sys.setenv(RETICULATE_PYTHON = "managed")
  reticulate::py_require(
    packages = c(
      "pyradiomics@git+https://github.com/AIM-Harvard/pyradiomics.git@v3.1.0",
      "scipy==1.13.1",
      "trimesh==3.23.5"
    )
  )

  radiomics <<- reticulate::import("radiomics", delay_load = TRUE)
}
