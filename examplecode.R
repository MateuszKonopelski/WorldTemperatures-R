sumfun<- function(x, display =FALSE, type=0, prob=FALSE) {
  if (display == FALSE) {
    cat("Summary of input:\n")
    return(summary(x))
  }
  if (display==TRUE) {
    if (type==0) {
      return(print("Please specify type as either hist or density"))
    }
    if(type=="density") {
      return(plot(density(x)))
    }
    if (type=="hist") {
      if (prob==TRUE) {
        return(hist(x, freq = FALSE))
      }
      if (prob==FALSE) {
        return(hist(x, freq = TRUE))
      }
    }
  }
}
set.seed(1234)
sumfun(rnorm(200), display = FALSE)
sumfun(rnorm(200), display = TRUE, type="hist", prob = TRUE)
