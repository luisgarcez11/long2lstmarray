library(testthat)


test_that("dimensions/type/output", {
  
  #get_var_sequence tests
  testthat::expect_length(get_var_sequence(data = alsfrs_data, 
                                           subj_var = "subjid", 
                                           subj = 1, var = "p1") , 8)
  testthat::expect_length(get_var_sequence(data = alsfrs_data, 
                                           subj_var = "subjid", 
                                           subj = 3, var = "p10") , 5)
  testthat::expect_true(is.vector(get_var_sequence(data = alsfrs_data, 
                                                   subj_var = "subjid", 
                                                   subj = 3, var = "p10")))
  testthat::expect_error(is.vector(get_var_sequence(data = alsfrs_data, 
                                                   subj_var = "subjid2", 
                                                   subj = 3, var = "p10")))
  testthat::expect_error(get_var_sequence(iris, subj = "setosa",
                                          subj_var = "Species",
                                          var = "beauty"))
  testthat::expect_error(get_var_sequence(iris, subj = "obama",
                                          subj_var = "Species",
                                          var = "Sepal.Length"))
  
  #slice_var_sequence tests
  sequence_example <- get_var_sequence(data = alsfrs_data, 
                                       subj_var = "subjid", 
                                       subj = 1, var = "p3")
  testthat::expect_length(slice_var_sequence(sequence = sequence_example,
                                             lags = 3, label_length = 1,
                                             label_output = TRUE), 2)
  testthat::expect_true(is.matrix(
    slice_var_sequence(sequence = sequence_example, 
                       lags = 3, 
                       label_length = 1,
                       label_output = FALSE)))
  
  testthat::expect_error(is.matrix(
    slice_var_sequence(sequence = c(1,2),
                       lags = 3,
                       label_length = 1,
                       label_output = FALSE)))
  
  #get_var_array tests
  testthat::expect_length(get_var_array(data = alsfrs_data,
                                        subj_var = "subjid", 
                                        var = "p5", 
                                        time_var ="visdy", 
                                        label_length = 1, 
                                        label_output = TRUE,
                                        lags = 3), 2)
  
  testthat::expect_error(get_var_array(data = alsfrs_data,
                                       subj_var = "subjid", 
                                       var = "p5", 
                                       time_var ="visdy2", 
                                       label_length = 1, 
                                       label_output = TRUE,
                                       lags = 3))
  
  testthat::expect_true(is.data.frame(get_var_array(data = alsfrs_data,
                                                    subj_var = "subjid",
                                                    var = "p5", 
                                                    time_var ="visdy",
                                                    label_length = 1,
                                                    label_output = FALSE,
                                                    lags = 3)))
  
  
})


