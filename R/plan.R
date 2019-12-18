plan <- drake_plan(
    raw_data = download_rawdata(file_in("01_data/data-raw/claimdata.rda"))
)