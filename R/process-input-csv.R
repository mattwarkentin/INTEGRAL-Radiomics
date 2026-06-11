process_input_csv <- function(input, quiet) {
  df <- readr::read_csv(input, show_col_types = !quiet, progress = !quiet)

  image <- check_files_exist(df$image, "`image`")
  mask <- check_files_exist(df$mask, "`mask`")
  age <- check_integer_range(df$age, c(0, 100), "age")
  female <- check_integer_level(df$sex, c(0, 1), "sex")
  fhlc <- check_integer_level(df$fhlc, c(0, 1), "fhlc")
  copdemph <- check_integer_level(df$copdemph, c(0, 1), "copdemph")
  formersmk <- check_integer_level(df$formersmk, c(0, 1), "formersmk")
  duration <- check_integer_range(df$duration, c(0, age), "duration")
  cigday <- check_integer_range(df$cigday, c(0, 100), "cigday")
  quittime <- check_integer_range(df$quittime, c(0, df$age), "quittime")
  bmi <- check_numeric_range(df$bmi, c(15, 50), "bmi")

  dplyr::tibble(
    study = "",
    pid = "",
    nid = 1:nrow(df),
    image = image,
    mask = mask,
    epi_age = age,
    epi_female = female,
    epi_fhlc = fhlc,
    epi_copdemph = copdemph,
    epi_formersmk = formersmk,
    epi_duration = duration,
    epi_cigday = cigday,
    epi_quittime = quittime,
    epi_bmi = bmi
  )
}
