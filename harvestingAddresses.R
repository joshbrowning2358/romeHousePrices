library(rvest)
mainPage = html("http://www.immobiliare.it/Roma/agenzie_immobiliari-Roma.html?pag=2")
agenzie = html_nodes(mainPage, "a")
sites = html_attr(agenzie, name = "href")
sites = sites[grepl("^http://www.immobiliare.it/agenzie.*html$", sites)]

individualAgenzie = html("http://www.immobiliare.it/agenzie_immobiliari/Residenze_Roma.html")
links = html_nodes(individualAgenzie, ".info")
links = html_attr(links, name = "onclick")
links = links[grepl("^http://", links)]
