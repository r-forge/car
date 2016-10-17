#include <Rcpp.h>
using namespace Rcpp;

//[[Rcpp::export]]
NumericVector AdaptiveKernel(NumericVector x0, NumericVector x, double h){
    int n = x.size();
    int len = x0.size();
    double nconst = 1.0/(n*h);
    NumericVector p(len);
    NumericVector f(n);
    NumericVector wts(n);
    for (int i = 0; i < len; ++i){
        wts = dnorm((x - x0[i])/h);
        p[i] = nconst * sum(wts);
    }
    for (int i = 0; i < n; ++i){
        int j = which_min(abs(x[i] - x0));
        f[i] = p[j];
    }
    double fbar = exp((1.0/n)*sum(log(f)));
    f = sqrt(f/fbar);
    for (int i = 0; i < len; ++i){
        wts = dnorm(f*(x - x0[i])/h);
        p[i] = nconst*sum(f*wts);
    }
    return p;
}
