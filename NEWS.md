# xpose.nlmixr2 0.4.2

* `xpose_data_nlmixr2()` now populates `$files` (parameter history) for all estimation methods that provide `par.hist`, not only SAEM (#6).
* `xpose_data_nlmixr2()` now stops with a descriptive error when weighted residuals (`wres`) or population predictions (`pred`) cannot be determined automatically, as happens with likelihood-based models using `ll()` or models without IIV. Users should specify these manually (e.g. `pred = "IPRED"`, `wres = "IWRES"`) (#7, #8).
* `xpose_data_nlmixr2()` no longer crashes with "undefined columns selected" when importing a fit without IIV and `pred`/`wres` are supplied manually (#8).

# xpose.nlmixr2 0.4.1

* Change to use `nlmixr2est` instead of `nlmixr2`

# xpose.nlmixr2 0.4.0

* Initial release
