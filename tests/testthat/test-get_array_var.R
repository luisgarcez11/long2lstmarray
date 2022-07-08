library(testthat)


test_that("dimensions", {
  
  testthat::expect_length(get_var_sequence(data = alsfrs_data, subj_var = "subjid", subj = 1, var = "p1") , 8)
  testthat::expect_length(get_var_sequence(data = alsfrs_data, subj_var = "subjid", subj = 3, var = "p10") , 5)
  testthat::expect_true(is.vector(get_var_sequence(data = alsfrs_data, subj_var = "subjid", subj = 3, var = "p10")))
  
  
  sequence_example = get_var_sequence(data = alsfrs_data, subj_var = "subjid", subj = 1, var = "p3")
  testthat::expect_length(slice_var_sequence(sequence = sequence_example, lags = 3, label_length = 1, label_output = TRUE), 2)
  testthat::expect_true(is.matrix(slice_var_sequence(sequence = sequence_example, lags = 3, label_length = 1, label_output = FALSE)))
  
  
})



slice_var_sequence(sequence = get_var_sequence(data = alsfrs_data, subj_var = "subjid", subj = 1, var = "p1"),
                   lags = 3,
                   label_length = 1,
                   label_output = TRUE)
