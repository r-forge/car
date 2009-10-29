showExtremes <- function(x, y, labels = NULL,
     ids = "xy", cex.id=.75, id.n=3, res=y-mean(y,na.rm=TRUE)) {
  if(id.n > 0L) {
    if (is.null(labels))
      labels <- paste(seq_along(x))
    getPoints <- function(z) {
       names(z) <- labels
       iid <- 1L:id.n
       zs <- z[order(-z)[iid]]
       match(names(zs),labels)
       }
    ind <- if (!is.character(ids)) {
      if (length(ids) == length(x)) getPoints(ids) else
      stop("identify.points argument is of wrong length")} else
      switch(ids,
        x= getPoints(abs(x-mean(x,na.rm=TRUE))),
        y= getPoints(abs(res)),
        xy= c(getPoints(abs(x-mean(x,na.rm=TRUE))),
              getPoints(abs(res))),
        mahal= getPoints(rowSums( qr.Q(qr(cbind(1,x,y))) ^ 2)))
  labpos <- c(4,2)[1+as.numeric(x > mean(range(x)))]
  for (i in ind) {
    text(x[i], y[i], labels[i], cex = cex.id, xpd = TRUE,
      pos = labpos[i], offset = 0.25)}
  } }



