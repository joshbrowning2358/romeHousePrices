library(rvest)

fail = try({
    htmlCode = read_html("http://www.tripadvisor.com/Restaurants-g187791-Rome_Lazio.html")
})
first = html_node(fail, ".first")
html_nodes(fail, ".sprite-ratings")
html_nodes(fail, ".property_title")
html_text(first)
html_name(first)
html_attrs(first)

rawText = gsub(".*cacheResponse", "", rawText)
rawText = gsub("\n.*", "", rawText)
rawTextVector = strsplit(rawText, ",")[[1]]
## Remove garbage from url, couldn't come up with a more clever way than
## referencing by position
eval(parse(text = paste0("list", rawText)))
