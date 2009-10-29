# Leverage plots (J. Fox)

# last modified 9 October 2009 by J. Fox

# these functions to be rewritten; simply renamed for now


leveragePlots<-function(model, term.name, ask=missing(term.name), ...){
	if (!missing(term.name)){
		var<-if (is.character(term.name) & 1==length(term.name)) term.name
			else deparse(substitute(term.name))
		leveragePlot(model, term.name, ...)
	}
	else {
		term.names<-term.names(model)
		if (ask) {
			repeat{
				selection<-menu(term.names)
				if (selection==0) break
				else term.name<-term.names[selection]
				leveragePlot(model, term.name, ...)
			}
		}
		else {
			for (term.name in term.names) leveragePlot(model, term.name, ...)
		}
	}
}


leveragePlot<-function (model, ...) {
	UseMethod("leveragePlot")
}

leveragePlot.lm<-function(model, term.name, 
	labels=names(residuals(model)[!is.na(residuals(model))]), 
	identify.points=TRUE, las=par("las"), col=palette()[2], pch=1, lwd=2, main="Leverage Plot", ...){
	term.name<-if (is.character(term.name) & 1==length(term.name)) term.name
		else deparse(substitute(term.name))
	b<-coefficients(model)
	e<-na.omit(residuals(model))
	p<-length(b)
	I.p<-diag(p)
	term.names<-term.names(model)
	term<-which(term.name==term.names)
	if (0==length(term)) stop(paste(term.name,"is not a term in the model."))
	responseName<-responseName(model)
	intercept<-has.intercept(model)
	assign<-model$assign
	X<-model.matrix(model)
	V<-vcov(model)
	wt<-if (is.null(weights(model))) rep(1, length(X[,1]))
		else weights(model)
	subs<-which(assign==term-intercept)
	hypothesis.matrix<-I.p[subs,]
	L<-if (is.null(dim(hypothesis.matrix))) t(hypothesis.matrix)
		else hypothesis.matrix
	u<-solve(L %*% V %*% t(L)) %*% L %*% b
	v.x<-X %*% V %*% t(L) %*% u
	v.y<-v.x + e
	plot(v.x, v.y, xlab=paste(term.names[term],"| others"), 
		ylab=paste(responseName," | others"), main=main,
		las=las, col=col, pch=pch)
	abline(lsfit(v.x, v.y, wt=wt), col=col, lwd=lwd)
	if (identify.points) identify(v.x, v.y, labels)
}

leveragePlot.glm<-function(model, ...){
	stop("leverage plot requires lm object")
}

