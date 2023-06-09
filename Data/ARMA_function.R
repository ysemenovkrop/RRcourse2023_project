# Compute AR roots
arroots <- function(dataset)
{
  if(!("Arima" %in% class(dataset)) &
     !("ar" %in% class(dataset)))
    stop("dataset must be of class Arima or ar")
  if("Arima" %in% class(dataset))
    parvec <- dataset$model$phi
  else
    parvec <- dataset$ar
  if(length(parvec) > 0)
  {
    last.nonzero <- max(which(abs(parvec) > 1e-08))
    if (last.nonzero > 0)
      return(structure(list(
        roots=polyroot(c(1,-parvec[1:last.nonzero])),
        type="AR"),
        class='armaroots'))
  }
  return(structure(list(roots=numeric(0), type="AR"),
                   class='armaroots'))
}

# Compute MA roots
maroots <- function(dataset)
{
  if(!("Arima" %in% class(dataset)))
    stop("dataset must be of class Arima")
  parvec <- dataset$model$theta
  if(length(parvec) > 0)
  {
    last.nonzero <- max(which(abs(parvec) > 1e-08))
    if (last.nonzero > 0)
      return(structure(list(
        roots=polyroot(c(1,parvec[1:last.nonzero])),
        type="MA"),
        class='armaroots'))
  }
  return(structure(list(roots=numeric(0), type="MA"),
                   class='armaroots'))
}

plot.armaroots <- function(x, xlab="Real", ylab="Imaginary",
                           main=paste("Inverse roots of", x$type,
                                      "characteristic polynomial"),
                           ...)
{
  oldpar <- par(pty='s')
  on.exit(par(oldpar))
  plot(c(-1,1), c(-1,1), xlab=xlab, ylab=ylab,
       type="n", bty="n", xaxt="n", yaxt="n", main=main, ...)
  axis(1, at=c(-1,0,1), line=0.5, tck=-0.025)
  axis(2, at=c(-1,0,1), label=c("-i","0","i"),
       line=0.5, tck=-0.025)
  circx <- seq(-1,1,l=501)
  circy <- sqrt(1-circx^2)
  lines(c(circx,circx), c(circy,-circy), col='gray')
  lines(c(-2,2), c(0,0), col='gray')
  lines(c(0,0), c(-2,2), col='gray')
  if(length(x$roots) > 0)
  {
    inside <- abs(x$roots) > 1
    points(1/x$roots[inside], pch=19, col='black')
    if(sum(!inside) > 0)
      points(1/x$roots[!inside], pch=19, col='red')
  }
}