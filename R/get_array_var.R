
#get a sequence from a variable, subject
get_var_sequence <- function(data, subj_var, subj, var){
  
  data[[var]][which(data[[subj_var]] == subj)]
}

#generate the sequences from the complete sequence
slice_var_sequence <- function(sequence, lags, label_length = 1, label_output = FALSE){
  
  x_vector <- sequence
  
  x_array <- array(data = NA, dim = c(length(x_vector) - (lags + label_length - 1) , lags))
  
  y_array <- c()
  
  for ( i in 1:dim(x_array)[1]){
    
    x_array[i,] <- x_vector[i:(i+lags-1)]
    y_array <- c(y_array, x_vector[i+lags + label_length - 1])
    
  }
  
  if(label_output){return(list("x" = x_array, "y" = y_array))}
  
  return(x_array)
  
}


get_var_array <- function(data, var, lags, label_length, label_output = FALSE, subj_var){
  
  #safeguard if the data is character
  if(is.character(data)){data <- eval(parse(text = data))}
  
  x_array = tibble()
  y_array = c()
  
  for ( subj in unique(data[,subj_var])){
    
    complete_sequence <- get_data_time(data = data, subj = subj, var = variable )
    
    if(length(complete_sequence) <= (lags + label_length - 1)){next}
    
    sequences <- get_sequences(sequence = complete_sequence, lags = lags, label_length = label_length)
    sequences_y <- get_sequences(sequence = complete_sequence, lags = lags, label_length = label_length, label_output = TRUE)$y
    
    y_array <- c(y_array, sequences_y)
    x_array <- x_array %>% rbind(sequences)
    
  }
  
  if(label_output == TRUE){ return(y_array) }
  
  if(label_output == FALSE){  
    #dim names
    dimnames(x_array)[[1]] <- paste0("seq", 1:nrow(x_array))
    dimnames(x_array)[[2]] <- paste0("time", 1:lags)
    
    return(x_array)}
  
}