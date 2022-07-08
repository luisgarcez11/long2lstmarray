longitudinal_array <- function(data, vars, label_var, lags, label_length, time_var,
                         label_output = FALSE, subj_var){
  
  #safeguard if the data is character
  if(is.character(data)){data <- eval(parse(text = data))}
  
  if(any(c(time_var, y_var, subj_variable) %in% vars)){vars <- vars[-which(vars %in% c(time_var, y_var, subj_variable)  )]}
  
  #time array
  x_array = get_array_var(data = data, variable = time_var, lags = lags, label_length = label_length)
  for( seq_i in 1:nrow(x_array)){time_seq <- unname(unlist(x_array[seq_i, ])); x_array[seq_i, ] <- (time_seq - time_seq[1]) }
  
  for (var in vars){
    
    x_array <- abind(x_array, 
                     get_array_var(data = data, variable = var, lags = lags, label_length = label_length),
                     along = 3) 
    
  }
  
  dimnames(x_array)[[3]] <- c(time_var, vars)
  
  return(x_array)
  
}
