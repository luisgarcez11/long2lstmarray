#' Generate a matrix with various lags from a dataframe
#'
#' @param data A data frame, data frame extension (e.g. a tibble), or a lazy data frame (e.g. from dbplyr or dtplyr).
#' @param subj_var A character string referring to the variable that specifies the "subject" variable.
#' @param vars A character string referring to the variables that contain the variable values.
#' @param time_var A character string referring to the variable that contains the time variable values (e.g. visit day, minutes, years). Important to get the sequences in the right order.
#' @param lags The length of each sliced sequence.
#' @param label_length How many values after are considered to be the label? Default to 1. If `label_length` = 1, the label value is always the value following the sliced sequence. 
#' @param label_var A character string referring to the variables that contain the label variable values.
#' @param label_output logical. if `TRUE` a list including the matrix with the sliced sequences and a vector with the label is returned.
#' @param time_var_output logical. Is `time_var` to be included in the final output. Default to `FALSE`.
#'
#' @return If `label_output` is `FALSE`, a 3D array with the sliced sequences is returned. The array dimensions are 1st: subject, 2nd: time, 3rd: variable. If `label_output` is `TRUE`, a list with the array and vector with the labels is returned.
#' @export
#'
#' @examples
#' longitudinal_array(alsfrs_data, "subjid", c("p1", "p2", "p3"), "visdy", lags = 3, label_output = FALSE)
#' longitudinal_array(alsfrs_data, "subjid", c("p1", "p2", "p3"), "visdy", lags = 3, label_output = FALSE)[1,,]
#' longitudinal_array(alsfrs_data, "subjid", c("p1", "p2", "p3"), "visdy", lags = 3, label_output = FALSE)[,1,]
#' longitudinal_array(alsfrs_data, "subjid", c("p1", "p2", "p3"), "visdy", lags = 3, label_output = FALSE)[,,1]
longitudinal_array <- function(data, subj_var, vars, time_var, lags, label_length = 1, label_var = NULL,
                         label_output = FALSE, time_var_output = FALSE){
  
  #safeguard if the data is character
  if(is.character(data)){data <- eval(parse(text = data))}
  
  #if label_output = TRUE, label_var must be specified
  if(is.null(label_var) & label_output == TRUE){stop("label variable must be specified if label output is TRUE")}
  
  #remove time_var, label_var, subj_var if they are in vars vector
  if(any(c(time_var, label_var, subj_var) %in% vars)){vars <- vars[-which(vars %in% c(time_var, label_var, subj_var)  )]}
  
  #time array
  x_array = get_var_array(data = data, subj_var = subj_var, var = time_var, 
                            time_var = time_var, lags = lags, label_length = label_length, label_output = FALSE)
  
  #label array
  if(label_output){
    y_array = get_var_array(data = data, subj_var = subj_var, var = label_var, time_var = time_var, lags = lags, label_length = label_length, label_output = label_output)$y
  }

  #getting time sequence
  for( seq_i in 1:nrow(x_array)){time_seq <- unname(unlist(x_array[seq_i, ])); x_array[seq_i, ] <- (time_seq - time_seq[1]) }
  
  #iterating over vars to consecutively binding the respective arrays
  for (var in vars){
    
    x_array <- abind(x_array, 
                     get_var_array(data = data, subj_var = subj_var, var = var, time_var = time_var, lags = lags, label_length = label_length),
                     along = 3) 
    
  }
  
  #setting dimension names
  dimnames(x_array)[[3]] <- c(time_var, vars)
  
  #remove time var if time_var_output == TRUE
  if(time_var_output){x_array <- x_array[,,-which(dimnames(x_array)[[3]] == time_var)]}
  
  #if label output is TRUE, return a list with the array and labels.
  if(label_output){return(list(x = x_array, y = y_array))}else{return(x_array)}
  
  
}
