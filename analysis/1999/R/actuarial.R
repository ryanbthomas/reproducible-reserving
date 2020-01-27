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
    NULL    
}

create_triangles <- function(x){
    tri_data <- aggregate_by_accident_year(x) %>%
       mutate(calendar_year = accident_year + development_year) %>%
       pivot_longer(cols = matches("(loss|count)"), 
                    names_to = "triangle_type",
                    values_to = "value")
    
        
    group_by(tri_data, triangle_type) %>% 
        group_split() 
   
}

estimate_factor <- function(next_value, value) {
    #assuming values are value and next_value
    if (length(next_value) < 2) {
        return(NA_real_)
    }
    
    model <- lm(next_value ~ 0 + value)
    factor <- model$coefficients['value']
    if( is.null(factor)) {
        return(NA_real_)
    }
    
    factor
}

create_latest_data <- function(enriched_data, pricing_data){
    aggregate_by_accident_year(enriched_data) %>% 
        ungroup() %>%
        filter(accident_year + development_year == 1999) %>% 
        inner_join(pricing_data, by = "accident_year") %>% 
        mutate(age = 12 * (development_year + 1)) %>% 
        select(accident_year, 
               age, 
               exposure, 
               premium, 
               priced_lossratio, 
               rep_count, 
               open_count, 
               closed_count, 
               inc_paid_loss, 
               cum_paid_loss)
}