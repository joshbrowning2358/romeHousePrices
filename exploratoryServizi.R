library(rvest)

fail = try({
    htmlCode = html("https://www.google.it/maps/search/bar/@41.8787315,12.5139177,14z")
})
rawText = html_text(htmlCode, "script")
rawText = gsub(".*cacheResponse", "", rawText)
rawText = gsub("\n.*", "", rawText)
rawTextVector = strsplit(rawText, ",")[[1]]
## Remove garbage from url, couldn't come up with a more clever way than
## referencing by position
eval(parse(text = paste0("list", rawText)))
