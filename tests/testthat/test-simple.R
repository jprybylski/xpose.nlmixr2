test_that("xpose_data object is valid", {
  one.cmt <- function() {
    ini({
      ## You may label each parameter with a comment
      tka <- 0.45 # Ka
      tcl <- log(c(0, 2.7, 100)) # Log Cl
      ## This works with interactive models
      ## You may also label the preceding line with label("label text")
      tv <- 3.45
      label("log V")
      ## the label("Label name") works with all models
      eta.ka ~ 0.6
      eta.cl ~ 0.3
      eta.v ~ 0.1
      add.sd <- 0.7
    })
    model({
      ka <- exp(tka + eta.ka)
      cl <- exp(tcl + eta.cl)
      v <- exp(tv + eta.v)
      linCmt() ~ add(add.sd)
    })
  }

  theo_sd_fit <- nlmixr2est::nlmixr2(
    one.cmt,
    nlmixr2data::theo_sd,
    "focei",
    control = nlmixr2est::foceiControl(print = 0)
  )

  xpdb_nlmixr2 <- xpose_data_nlmixr2(theo_sd_fit)

  # Basic checks
  expect_true(xpose::is.xpdb(xpdb_nlmixr2))

  expect_no_error(xpose::check_xpdb(xpdb_nlmixr2))

  # Summary checks
  typical_labels <- xpose::xpdb_ex_pk$summary$label
  expect_setequal(
    typical_labels,
    xpdb_nlmixr2$summary$label
  )

  # par.hist available for focei: files should be populated
  expect_false(is.null(xpdb_nlmixr2$files))
  expect_equal(xpdb_nlmixr2$files$method, "focei")
  expect_true("ITERATION" %in% names(xpdb_nlmixr2$files$data[[1]]))
})

test_that("FOCEi fit with eta fixed to zero (eta ~ 0) succeeds (#10)", {
  one.cmt.fixed.ka <- function() {
    ini({
      tka <- 0.45
      tcl <- log(2.7)
      tv <- 3.45
      eta.ka ~ 0
      eta.cl ~ 0.3
      eta.v ~ 0.1
      add.sd <- 0.7
    })
    model({
      ka <- exp(tka + eta.ka)
      cl <- exp(tcl + eta.cl)
      v <- exp(tv + eta.v)
      linCmt() ~ add(add.sd)
    })
  }

  fit_fixed_ka <- nlmixr2est::nlmixr2(
    one.cmt.fixed.ka,
    nlmixr2data::theo_sd,
    "focei",
    control = nlmixr2est::foceiControl(print = 0)
  )

  xpdb <- xpose_data_nlmixr2(fit_fixed_ka)
  expect_true(xpose::is.xpdb(xpdb))
})

test_that("no-IIV fit without pred/wres gives a descriptive error (#8)", {
  no_bsv <- function() {
    ini({
      tka <- 0.45
      tcl <- log(2.7)
      tv <- 3.45
      add.sd <- 0.7
    })
    model({
      ka <- exp(tka)
      cl <- exp(tcl)
      v <- exp(tv)
      linCmt() ~ add(add.sd)
    })
  }

  fit_no_bsv <- nlmixr2est::nlmixr2(
    no_bsv,
    nlmixr2data::theo_sd,
    "focei",
    control = nlmixr2est::foceiControl(print = 0)
  )

  expect_snapshot(error = TRUE, xpose_data_nlmixr2(fit_no_bsv))
})

test_that("no-IIV fit with manual pred/wres succeeds (#8)", {
  no_bsv <- function() {
    ini({
      tka <- 0.45
      tcl <- log(2.7)
      tv <- 3.45
      add.sd <- 0.7
    })
    model({
      ka <- exp(tka)
      cl <- exp(tcl)
      v <- exp(tv)
      linCmt() ~ add(add.sd)
    })
  }

  fit_no_bsv <- nlmixr2est::nlmixr2(
    no_bsv,
    nlmixr2data::theo_sd,
    "focei",
    control = nlmixr2est::foceiControl(print = 0)
  )

  xpdb <- xpose_data_nlmixr2(fit_no_bsv, pred = "IPRED", wres = "IWRES")
  expect_true(xpose::is.xpdb(xpdb))
})
