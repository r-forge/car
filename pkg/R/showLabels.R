# methods:
#   'x' x - mean(x)
#   'y' y - mean(y)
#   'xy' both 'x' and 'y'
#   'mahal' rowSums( qr.Q(qr(cbind(1,x,y))) ^ 2

showLabels <- function(x, y, id.var = NULL, 
     labels = if(is.null(id.var)) NULL else names(id.var),
     id.method = if(is.null(id.var)) "xy" else "none",
     id.n = 3, id.cex = .75, show=TRUE, ...) {
  if (id.n <= 0L ) 
     return()
  if (is.null(labels))
     labels <- paste(seq_along(x))
  all.inds <- NULL
  if (!is.null(id.var)) {
     all.inds <- showLabels(x, y, NULL, labels, id.method, id.n, id.cex, show)
     if (length(id.var) == length(x))
        ind <- order(-abs(id.var))[1L:id.n] else
        ind <- if(is.character(id.var)) match(id.var, labels) else id.var
     } else { 
     if (id.method == "xy") { return(c(
        showLabels(x, y, NULL, labels, id.method="x", id.n, id.cex),
        showLabels(x, y, NULL, labels, id.method="y", id.n, id.cex)))} else {
     id.var <- switch(id.method,
        none = return(),
        identify = return(identify(x, y, labels, cex=id.cex, ...)),
        x = x - mean(x, na.rm = TRUE),
        y = y - mean(y, na.rm = TRUE),
        mahal = rowSums( qr.Q( qr(cbind(1, x, y) ) )^2))}
     ind <-  order(-abs(id.var))[1L:id.n]
     }
  labpos <- c(4,2)[1+as.numeric(x > mean(range(x)))]
# add the labels if show == TRUE
  if (show == TRUE) {
    for (i in ind) {
      text(x[i], y[i], labels[i], cex = id.cex, xpd = TRUE,
        pos = labpos[i], offset = 0.25, ...)}
    }
  return(unique(c(all.inds,labels[ind])))
  }
     





