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
    
        
    res <- group_by(tri_data, triangle_type) %>% 
        group_split()
    
    attributes(res) <- NULL
    
    res_names <- map_chr(res, ~ .x$triangle_type[1])
    
    setNames(res, res_names)
   
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

make_ldfs <- function(triangles){
    link_ratios <- map_dfr(triangles, 
                           ~ tibble(ldfs = list(estimate_age_to_age(.x))), 
                           .id = "triangle_type") %>%
        group_by(triangle_type) %>%
        mutate(factors = list(select_age_to_age(ldfs[[1]], triangle_type)))
    
    link_ratios
}

estimate_age_to_age <- function(triangle) {
    triangle %>%
        group_by(accident_year) %>% 
        mutate(age = 12 * (development_year + 1), next_value = lead(value)) %>% 
        group_by(age) %>% 
        summarize(age_to_age = estimate_factor(next_value, value)) %>%
        fit_age_to_age()
}

fit_age_to_age <- function(link_ratios) {
    model <- lm(log(age_to_age) ~ log(age), data = link_ratios)
    est_values <- exp(predict(model, newdata = link_ratios[, "age"]))
    mutate(link_ratios, est_values = est_values)
}

select_age_to_age <- function(link_ratios, triangle_type){
    final_factors <- switch (triangle_type,
        "inc_paid_loss" = mutate(link_ratios, select_values = est_values) %>% 
                                select(age, select_values),
        "open_count" = mutate(link_ratios, select_values = pmin(age_to_age, est_values)) %>%
                                mutate(select_values = ifelse(is.na(select_values), 0.5, select_values)),
        mutate(link_ratios, select_links = pmax(est_values, 1), select_values = cumprodrev(select_links))
    )
    
    select(final_factors, age, select_values)
}    
cumprodrev <- function(x) {
    tmp <- cumprod(x[length(x):1])
    tmp[length(tmp):1]
}
    
