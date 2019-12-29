generate_claim_data <- function(db_location) {
    
# I'm using the simulation machine to generate data for this example. For
# more information check out the blog post on the kasa.ai website 
# (https://blog.kasa.ai/posts/simulation-machine/)

    charm <- simulationmachine::simulation_machine(
        num_claims = 50000, 
        lob_distribution = c(0.25, 0.25, 0.30, 0.20), 
        inflation = c(0.01, 0.01, 0.01, 0.01), 
        sd_claim = 0.85, 
        sd_recovery = 0.75
    )
    
    claim_history <- simulationmachine::conjure(charm, seed = 1234)
    #proj_directory <- here::here() 
    saveRDS(claim_history, file = db_location)

}

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
    
    save_data <- function(x, fname) {
        saveRDS(x, file = fs::path(data_objects_dir, fname))
        invisible(x)
    }
    
    enriched_data <- raw_data %>% 
        clean_data() %>%
        enrich_data()
    
    save_data(enriched_data,"enriched_data.rda")
    #saveRDS(enriched_data, file = fs::path(data_objects_dir, "enriched_data.rda"))
    save_data(identify_large_losses(enriched_data), "large_losses.rda")
    
    aggregate_data <- save_data(
        aggregate_by_accident_year(enriched_data),
        "aggregate_data.rda"
    )
    
    save_data(
        dplyr::filter(aggregate_data, accident_year + development_year == 2000),
        "latest_eval.rda"
    )
    
    
    save_data(
        dplyr::filter(aggregate_data, accident_year + development_year == 1999),
        "prior_eval.rda"
    )
    
}

clean_data <- function(x) {
    # This is mostly a placeholder for data cleaning that should happen with 
    # real data.  Here we are only renaming a column to a more clear name
    # 
    dplyr::mutate(x, inc_paid_loss = paid_loss)
}

aggregate_by_accident_year <- function(x) {
    grp_data <- dplyr::group_by(x, accident_year, development_year)
    
    dplyr::summarise(grp_data,
        rep_count = sum(rep_count),
        open_count = sum(open_count),
        closed_count = sum(closed_count),
        inc_paid_loss = sum(paid_loss),
        cum_paid_loss = sum(cum_paid_loss)             
    )
}

enrich_data <- function(x) {
    enriched_data <- x %>%
        dplyr::mutate(
            rep_count = 1 * (report_delay <= development_year), 
            open_count = rep_count * claim_status_open,
            closed_count = rep_count - open_count) %>%
        dplyr::group_by(claim_id) %>%
        dplyr::arrange(development_year) %>%
        dplyr::mutate(cum_paid_loss = cumsum(inc_paid_loss))
    
    enriched_data
}