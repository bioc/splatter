context("lunEstimate")

library(scuttle)
set.seed(1)
counts <- counts(mockSCE())

test_that("lunEstimate works", {
    params <- lunEstimate(counts)
    expect_true(validObject(params))
})
