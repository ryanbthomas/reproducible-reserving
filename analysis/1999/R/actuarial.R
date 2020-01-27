calc_chainladder <- function(x, col, ldf) {
    if (!("data.frame" %in% class(ldf))) {
        stop("`ldf` must inherit from data.frame", call. = FALSE)
    }
    if (!("data.frame" %in% class(x))) {
        stop("`x` must inherit from data.frame", call. = FALSE)
    }
    if (!all(c("age", "factor") %in% colnames(ldf))) {
        stop("Required colnames 'age' and 'factor' not found in `ldf`", call. = FALSE)
    }
    if (!("age" %in% colnames(x))) {
        stop("Required colname 'age' not found in `x`", call. = FALSE)
    }
    
    var <- rlang::quo(col)
    dplyr::inner_join(x, ldf, by = "age") %>%
        dplyr::mutate(estimate = var * ldf) %>%
        dplyr::pull(estimate)
}

calc_capecod <- function(x, ldfs){
    
}