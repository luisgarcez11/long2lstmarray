
test_that("dimensions/type", {

  
  obj <- longitudinal_array(data = alsfrs_data, subj_var = "subjid", vars = c("p1", "p2", "p3"), time_var = "visdy", label_var = "p4", lags = 5, 
                     label_length = 1, label_output = TRUE)
  
  testthat::expect_length(obj, 2)
  testthat::expect_true(is.array(obj[[1]]))
  
  obj <- longitudinal_array(data = alsfrs_data, subj_var = "subjid", vars = c("p1", "p2", "p3"), time_var = "visdy", lags = 5, 
                            label_length = 1, label_output = FALSE)
  
  testthat::expect_true(is.array(obj))
  
  
})
