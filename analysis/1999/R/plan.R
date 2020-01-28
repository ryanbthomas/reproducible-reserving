plan <- drake_plan(
    raw_data = fetch_rawdata(file_in("data/1999-12-31_control-totals.xlsx")),
    pricing_data = load_pricingdata(file_in("data/1999-12-31_pricingdata.xlsx")),
    #prior_data = load_priordata(file_in("data/"))
    enriched_data = clean_enrich_data(raw_data),
    triangles = create_triangles(enriched_data),
    latest_data = create_latest_data(enriched_data, pricing_data),
    #diagnostics
    ldfs = make_ldfs(triangles)
    #estimates = make_estimates(latest_data, ldfs),
    # report
    
)