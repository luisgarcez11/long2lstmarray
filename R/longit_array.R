longitudinal_array <- function(data, subj_var, vars, time_var, lags, label_length, label_var = NULL,
                         label_output = FALSE){
  
  #safeguard if the data is character
  if(is.character(data)){data <- eval(parse(text = data))}
  
  #if label_output = TRUE, label_var must be specified
  if(is.null(label_var) & label_output == TRUE){stop("label variable must be specified if label output is TRUE")}
  
  if(any(c(time_var, label_var, subj_var) %in% vars)){vars <- vars[-which(vars %in% c(time_var, label_var, subj_var)  )]}
  
  #time array
  x_array = get_var_array(data = data, subj_var = subj_var, var = time_var, time_var = time_var, lags = lags, 
                          label_length = label_length, label_output = FALSE)
  
  #label array
  if(label_output){
    y_array = get_var_array(data = data, subj_var = subj_var, var = label_var, time_var = time_var, lags = lags, label_var = label_var, label_length = label_length, label_output = label_output)$y
  }

  
  for( seq_i in 1:nrow(x_array)){time_seq <- unname(unlist(x_array[seq_i, ])); x_array[seq_i, ] <- (time_seq - time_seq[1]) }
  
  for (var in vars){
    
    x_array <- abind(x_array, 
                     get_var_array(data = data, subj_var = subj_var, var = var, time_var = time_var, lags = lags, label_length = label_length),
                     along = 3) 
    
  }
  
  dimnames(x_array)[[3]] <- c(time_var, vars)
  
  
  if(label_output){return(list(x = x_array, y = y_array))}else{return(x_array)}
  
  
}
