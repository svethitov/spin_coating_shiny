# loading libraries
library(googlesheets)
suppressMessages(library(dplyr))

#function that gets the data from the google sheets
fullData <- function(){
  sheet <- gs_url("https://docs.google.com/spreadsheets/d/18NUQKoGEH3fFEj26mAsbmoPHN87oRtiwZrEp0dtkKIc/edit?usp=sharing")
  my_data <- gs_read(sheet)
  my_data$date <- as.Date(my_data$date, "%d/%m/%Y")
  my_data$substrate <- as.factor(my_data$substrate)
  return(my_data)
}

# function that subsets data frame for histograms
subsetData <- function(hTarget, tSubstrate, data){
  if (tSubstrate == "All") {
    x <- subset(data, 
                target == as.numeric(hTarget), 
                select = "thickness")
  }
  else {
    x <- subset(data, 
                target == as.numeric(hTarget) & substrate == tSubstrate, 
                select = "thickness")
  }
  return(x)
}

# function that makes fitting of the function
fitting <- function(data = fullData){
  a <- 300
  n <- 1
  alpha <- -0.3
  tau <- -0.1
  fit <- nls(thickness ~ a * concentration^n / ( angular_momentum^alpha * spin_time^tau ), 
             data = data , start=list(a=a,n=n,alpha=alpha,tau=tau))
  return(fit)
}

