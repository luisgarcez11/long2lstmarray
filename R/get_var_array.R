
#' Get variable values from subject/variable name pair
#'
#' @param data A data frame, data frame extension (e.g. a tibble).
#' @param subj_var A character string referring to the variable 
#' that specifies the "subject" variable.
#' @param subj Any value that the "subject" variable can take.
#' @param var A character string referring to the variable that 
#' contains the variable values.
#'
#' @return A vector of values from variable `var`
#'  which `subj_var` equal to `subj`.
#' @export
#'
#' @examples 
#' get_var_sequence(sleep, subj_var = "ID", 1, "extra")
get_var_sequence <- function(data, subj_var, subj, var){
  
  if(!var %in% names(data)){stop("variable is not part of data")}
  if(!subj_var %in% names(data)){stop("subject variable is not part of data")}
  if(!subj %in% data[[subj_var]]){stop("subject is not part of data")}
  
  data[[var]][which(data[[subj_var]] == subj)]
}

#' Generate a matrix with various lags from a sequence
#'
#' @param sequence A vector representing the sequence
#'  to be sliced into many rows.
#' @param lags The length of each sliced sequence.
#' @param label_length How many values after are 
#' considered to be the label? Default to 1.
#'  If `label_length` = 1, the label value is always
#'   the value following the sliced sequence. 
#' @param label_output logical. if `TRUE` a list 
#' including the matrix with the sliced 
#' sequences and a vector with the labels is returned.
#'
#' @return If `label_output` is `FALSE`, a matrix with 
#' the sliced sequences is returned. 
#' If `label_output` is `TRUE`, a list with 
#' the matrix and vector with 
#' the labels is returned.
#' @export
#'
#' @examples
#' slice_var_sequence(sequence = 1:30,
#'  lags = 3, label_length = 1,
#'  label_output = TRUE)
#'  
#' slice_var_sequence(sequence = 1:30, 
#' lags = 3, label_length = 1,
#'  label_output = FALSE)
#'  
#' slice_var_sequence(sequence = 1:30,
#'  lags = 3, label_length = 2,
#'   label_output = FALSE)
slice_var_sequence <- function(sequence, lags, label_length = 1,
                               label_output = TRUE){
  
  #sequence must be long enough
  if(length(sequence) <= (lags + label_length - 1)){
    stop("sequence is not long enough")}
  
  x_vector <- sequence
  
  x_array <- array(data = NA, 
                   dim = c(length(x_vector) - (lags + label_length - 1) , lags))
  
  y_array <- c()
  
  for ( i in 1:dim(x_array)[1]){
    
    x_array[i,] <- x_vector[i:(i+lags-1)]
    y_array <- c(y_array, x_vector[i+lags + label_length - 1])
    
  }
  
  if(label_output){return(list("x" = x_array, "y" = y_array))}
  
  return(x_array)
  
}


#' Generate a matrix with various lags from a variable in the dataframe
#'
#' @param data A data frame, data frame extension (e.g. a tibble).
#' @param subj_var A character string referring to the variable that 
#' specifies the "subject" variable.
#' @param var A character string referring to the variable that 
#' contains the variable values.
#' @param time_var A character string referring to the variable 
#' that contains the time variable values (e.g. visit day, minutes, years).
#' @param lags The length of each sliced sequence.
#' @param label_length How many values after are considered to 
#' be the label? Default to 1. If `label_length` = 1, the label value´
#'  is always the value following the sliced sequence. 
#' @param label_output logical. if `TRUE` a list including the 
#' matrix with the sliced sequences and a vector with the 
#' label is returned.
#'
#' @importFrom dplyr %>%
#' @importFrom dplyr tibble
#'
#' @return If `label_output` is `FALSE`, 
#' a matrix with the sliced sequences is returned. 
#' If `label_output` is `TRUE`, a list with the matrix
#'  and vector with the labels from the same variable is returned.
#' @export
#'
#' @examples
#' get_var_array(alsfrs_data, "subjid", 
#' "p2", "visdy", lags = 3, 
#' label_output = FALSE)
get_var_array <- function(data, subj_var, var, time_var,
                          lags,  label_length = 1, 
                          label_output = FALSE){
  
  #time variable must be part of data
  if(!time_var %in% names(data)){stop("time variable is not part of data")}
  
  data <- data %>% arrange(subj_var, time_var)
  
  x_array <-  tibble()
  y_array <- c()
  
  for ( subj in unlist(unique(data[,subj_var]))){
    
    complete_sequence <- get_var_sequence(data = data,
                                          subj_var = subj_var,
                                          subj = subj, var = var)
    
    if(length(complete_sequence) <= (lags + label_length - 1)){next}
    
    sequences <- slice_var_sequence(sequence = complete_sequence, 
                                    lags = lags, label_length = label_length,
                                    label_output = TRUE)$x
    sequences_y <- slice_var_sequence(sequence = complete_sequence,
                                      lags = lags, label_length = label_length,
                                      label_output = TRUE)$y
    
    y_array <- c(y_array, sequences_y)
    x_array <- x_array %>% rbind(sequences)
    
  }
  
  
  #dim names
  dimnames(x_array)[[1]] <- paste0("seq", seq_along(x_array[[1]]))
  dimnames(x_array)[[2]] <- paste0("time", seq_len(lags))
  
  if(label_output == TRUE){ 
    
    return(list(x = x_array, y = y_array))
    
    }
  
  if(label_output == FALSE){  
    
    
    return(x_array)}
  
}
