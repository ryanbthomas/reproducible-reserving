library(simulationmachine)

# I'm using the simulation machine to generate data for this example. For
# more information check out the blog post on the kasa.ai website 
# (https://blog.kasa.ai/posts/simulation-machine/)

local({
    charm <- simulation_machine(
        num_claims = 50000, 
        lob_distribution = c(0.25, 0.25, 0.30, 0.20), 
        inflation = c(0.01, 0.01, 0.01, 0.01), 
        sd_claim = 0.85, 
        sd_recovery = 0.75
    )
    
    claim_history <- conjure(charm, seed = 1234)
    proj_directory <- here::here() 
    saveRDS(
        claim_history, 
        file = glue::glue("{proj_directory}/database/claimdata.rda")
    )

})