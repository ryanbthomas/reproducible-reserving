download_rawdata <- function(db_location, data_location) {
    # In a real life example with would be accomplished by querying a database or
    # reading data from a csv or spreadsheet.
    simulated_claims <- readRDS(db_location)
    
    raw_data <- dplyr::filter(simulated_claims, 
                  accident_year + development_year <= 2000, 
                  lob == "1"
    )
    
    saveRDS(raw_data, file = data_location)
    
}

prepare_analysis_objects <- function(raw_data_file, data_objects_dir) {
    raw_data <- readRDS(raw_data_file)
    
    aggregate_data <- raw_data %>% 
        clean_data() %>% 
        enrich_data()
    
    saveRDS(aggregate_data, file = fs::path(data_objects_dir, "aggregate_data.rda"))
    
    latest_eval <- dplyr::filter(aggregate_data, 
                                 accident_year + development_year == 2000)
    
    saveRDS(latest_eval, file = fs::path(data_objects_dir, "latest_eval.rda"))
}

clean_data <- function(x) {
    # this is a placeholder for data cleaning that should happen with real data
    # it's not necessary in this example as the data is simulated.
    x
}

enrich_data <- function(x) {
     
    enriched_data <- x %>%
        dplyr::mutate(
            rep_count = 1 * (report_delay <= development_year), 
            open_count = rep_count * claim_status_open,
            closed_count = rep_count - open_count) %>%
        dplyr::group_by(accident_year, development_year) %>% 
        dplyr::summarise(
        rep_count = sum(rep_count),
        open_count = sum(open_count),
        closed_count = sum(closed_count),
        inc_paid_loss = sum(paid_loss)
    ) %>% 
    dplyr::mutate(cum_paid_loss = cumsum(inc_paid_loss))
    
    enriched_data
}