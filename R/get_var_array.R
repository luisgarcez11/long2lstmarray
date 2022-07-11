
#get a sequence from a variable, subject
get_var_sequence <- function(data, subj_var, subj, var){
  
  if(!var %in% names(data)){stop("variable is not part of data")}
  if(!subj_var %in% names(data)){stop("subject variable is not part of data")}
  if(!subj %in% data[[subj_var]]){stop("subject is not part of data")}
  
  data[[var]][which(data[[subj_var]] == subj)]
}

#generate the sequences from the complete sequence
slice_var_sequence <- function(sequence, lags, label_length, label_output = TRUE){
  
  #sequence must be long enough
  if(length(sequence) <= (lags + label_length - 1)){stop("sequence is not long enough")}
  
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


get_var_array <- function(data, subj_var, var, time_var, lags, label_var, label_length, label_output = FALSE){
  
  #time var must be part of data
  if(!time_var %in% names(data)){stop("time variable is not part of data")}
  
  #safeguard if the data is character
  if(is.character(data)){data <- eval(parse(text = data))}
  
  data <- data %>% arrange(subjid, time_var)
  
  x_array = tibble()
  y_array = c()
  
  for ( subj in unlist(unique(data[,subj_var]))){
    
    complete_sequence <- get_var_sequence(data = data, subj_var = subj_var, subj = subj, var = var)
    
    if(length(complete_sequence) <= (lags + label_length - 1)){next}
    
    sequences <- slice_var_sequence(sequence = complete_sequence, lags = lags, label_length = label_length, label_output = TRUE)$x
    sequences_y <- slice_var_sequence(sequence = complete_sequence, lags = lags, label_length = label_length, label_output = TRUE)$y
    
    y_array <- c(y_array, sequences_y)
    x_array <- x_array %>% rbind(sequences)
    
  }
  
  
  #dim names
  dimnames(x_array)[[1]] <- paste0("seq", 1:nrow(x_array))
  dimnames(x_array)[[2]] <- paste0("time", 1:lags)
  
  if(label_output == TRUE){ 
    
    return(list(x = x_array, y = y_array))
    
    }
  
  if(label_output == FALSE){  
    
    
    return(x_array)}
  
}
