carWeb <-
function (what = c("webpage", "errata", "taskviews"))
{
    what = match.arg(what)
    urls = c(webpage = "http://www.stat.umn.edu/alr/",
        errata = "http://www.stat.umn.edu/alr/Links/errata.pdf",
        taskviews = "http://cran.r-project.org/web/views")
    url = urls[what]
    browseURL(url)
}