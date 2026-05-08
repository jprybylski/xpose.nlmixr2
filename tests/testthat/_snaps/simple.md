# no-IIV fit without pred/wres gives a descriptive error (#8)

    Code
      xpose_data_nlmixr2(fit_no_bsv)
    Condition
      Error:
      ! Could not automatically determine the weighted residual column. The fit does not contain CWRES, NPDE, or RES. For models without IIV or using ll(), specify `pred` and `wres` manually (e.g. pred = "IPRED", wres = "IWRES").

