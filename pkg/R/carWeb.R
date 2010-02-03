carWeb <-
function (what = c("webpage", "errata", "taskviews"))
{
    what = match.arg(what)
    urls = c(webpage = "http://socserv.socsci.mcmaster.ca/jfox/Books/Companion/",
        errata = "http://socserv.socsci.mcmaster.ca/jfox/Books/Companion/errata.pdf",
        taskviews = "http://cran.r-project.org/web/views")
    url = urls[what]
    browseURL(url)
}