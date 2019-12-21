plan <- drake_plan(
    # step 1 should be
    # - download
    # - clean
    # - enrich
    # - create analysis objects
    raw_data = download_rawdata(
        file_in("01_data/data-raw/claimdata.rda"), 
        file_out("01_data/raw_data.rda")),
    prepare_data = prepare_analysis_objects(
        file_in("01_data/raw_data.rda"),
        file_out("01_data/analysis_data"))
)