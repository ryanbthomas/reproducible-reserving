download_rawdata <- function(db_location) {
    # In a real life example with would be accomplished by querying a database or
    # reading data from a csv or spreadsheet.
    simulated_claims <- readRDS(db_location)
    
    dplyr::filter(simulated_claims, 
                  accident_year + development_year <= 2000, 
                  lob == "1"
    )
    
}