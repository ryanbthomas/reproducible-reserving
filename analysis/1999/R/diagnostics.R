
identify_large_losses <- function(x) {
   latest_two_evals <- x %>% 
        dplyr::filter(accident_year + development_year >= 1999) %>% 
        dplyr::mutate(
            eval = dplyr::case_when(
               accident_year + development_year == 1999 ~ "prior", 
               TRUE                                     ~ "latest"
            )    
        ) 
   
    large_loss_claim_ids <- latest_two_evals %>% 
        dplyr::group_by(eval) %>% 
        dplyr::top_n(20, cum_paid_loss) %>%
        dplyr::pull(claim_id) %>%
        unique()
    
    large_losses <- latest_two_evals %>%
        filter(claim_id %in% large_loss_claim_ids)
    
    large_losses 
}