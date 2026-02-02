#Create vector containing the value of each Russian unit in metres, and names of all units
russian_units <- c(1066.8, 2.1336, 0.7112, 0.04445)
rnames <- c("verst", "sazhen", "arshin", "vershok")
mnames <- c("km", "m", "cm")

#Expand the vector of Russian units to a matrix with one column each for values in km, m, and cm
metric_expand <- function(x) cbind(x/1000, x, x*100)
conv_matrix <- metric_expand(russian_units)

#This function displays values in all units other than the one that is input
convert_units <- function(value, unit){
  if(unit %in% rnames){
    unum <- which(rnames==unit)
    conv_metric <- conv_matrix[unum,]
    conv_russian <- conv_matrix[unum, 2]/conv_matrix[-unum, 2]
  }
  else if(unit %in% mnames){
    unum <- which(mnames==unit)
    conv_metric <- conv_matrix[2, -unum]/conv_matrix[2, unum]
    conv_russian <- 1/conv_matrix[,unum]
  }
  results <- value*c(conv_metric, conv_russian)
  allnames <- c(mnames, rnames)
  paste(results, allnames[allnames!=unit]) |> writeLines()
}

#Test inputs
convert_units(1, "m")
convert_units(1, "arshin")
