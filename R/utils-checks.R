check_integer_range <- function(x, rng, nm) {
  if (rlang::is_integerish(x) & all(x >= rng[1]) & all(x <= rng[2])) {
    return(x)
  }
  rlang::abort(
    message = glue::glue(
      "`{nm}` must be an integer between {rng[1]} and {rng[2]}."
    )
  )
}

check_integer_level <- function(x, rng, nm) {
  if (rlang::is_integerish(x) & all(x %in% rng)) {
    return(x)
  }
  rlang::abort(
    message = glue::glue(
      "`{nm}` must be an integer ({glue::glue_collapse(rng, sep = ',')})}."
    )
  )
}

check_numeric_range <- function(x, rng, nm) {
  if (rlang::is_double(x) & all(x >= rng[1]) & all(x <= rng[2])) {
    return(x)
  }
  rlang::abort(
    message = glue::glue(
      "`{nm}` must be a float between {rng[1]} and {rng[2]}."
    )
  )
}

check_files_exist <- function(x, type) {
  if (all(fs::file_exists(x))) {
    return(x)
  }
  rlang::abort(
    message = glue::glue("Not all {type} files exist.")
  )
}
