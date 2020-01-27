fetch_rawdata <- function(control_file) {
    db_location <- paste0(here(), "/../../database/claimdata.rda")
    analysis_year <- 1999
    
    control_totals <- read_excel(control_file) %>%
       mutate(calendar_year = as.integer(calendar_year),
                    count = as.integer(count)
                     )
    
    
    db_result <- readRDS(db_location) %>%
        filter(accident_year + development_year <= analysis_year,
               lob == "1")
    
    assert_that(
        are_equal(control_totals, summarise_calyear(db_result))
    )
    
    db_result
}

summarise_calyear <- function(x) {
   mutate(x, calendar_year = accident_year + development_year) %>% 
        dplyr::group_by(calendar_year) %>%
        dplyr::summarise(count = n(), total = sum(paid_loss))
 
}

load_pricingdata <- function(pricing_file) {
    read_excel(pricing_file, 
                       sheet = "pricing",
                       col_names = c("accident_year", 
                                     "exposure", 
                                     "premium", 
                                     "priced_lossratio"),
                       skip = 1
                       ) %>%
        mutate(accident_year = as.integer(accident_year),
                      exposure = round(exposure),
                      premium = round(premium))
        
}