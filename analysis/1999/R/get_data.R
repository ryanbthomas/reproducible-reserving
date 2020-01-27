fetch_rawdata <- function(control_file) {
    db_location <- paste0(here::here(), "/../../database/claimdata.rda")
    analysis_year <- 1999
    
    control_totals <- readxl::read_excel(control_file) %>%
       dplyr::mutate(calendar_year = as.integer(calendar_year),
                    count = as.integer(count)
                     )
    
    
    db_result <- readRDS(db_location) %>%
        filter(accident_year + development_year <= analysis_year,
               lob == "1")
    
    assertthat::assert_that(
        assertthat::are_equal(control_totals, summarise_calyear(db_result))
    )
    
    db_result
}

summarise_calyear <- function(x) {
   dplyr::mutate(x, calendar_year = accident_year + development_year) %>% 
        dplyr::group_by(calendar_year) %>%
        dplyr::summarise(count = n(), total = sum(paid_loss))
 
}
