# htmlwidget-hexjson

Simple R/[htmlwidget](http://www.htmlwidgets.org/) for displaying hexjson maps based on Oli Hawkins' [d3-hexjson](https://github.com/olihawkins/d3-hexjson) package,  a D3 module for generating hexmaps from data in the Open Data Institute's [HexJSON format](https://odileeds.org/projects/hexmaps/hexjson.html).

Download and unzip the folder, cd into it and install with: `devtools::install()` or install directly from Github:

    library(devtools)
    install_github("psychemedia/htmlwidget-hexjson")

Documentation is generated automatically using `roxygen2` via the command `devtools::document()`.

An example *Rmd* file is in the test folder. Or run:

````
library(jsonlite)
library(hexjsonwidget)
jj=fromJSON('./example.hexjson')
hexjsonwidget(jj)
````

in RStudio to display the rendered example file in the RStudio viewer.

Support added for grid display:

````
jj=fromJSON('./example-grid.hexjson')
hexjsonwidget(jj, grid='on')
````

Colour is supported in a variety of ways:

- specify hex fill colour: `hexjsonwidget(jj, col_hexfill='#bb3388')`
- specify grid fill colour: `hexjsonwidget(jj, grid='on', col_gridfill='#113355')`

You can specify a hex attribute to be used to set the fill colour of a hex using the `colour` parameter (default(`col`):  `hexjsonwidget(jsonbase="example-grid.hexjson", colour='col')`.

If `colour = NA`, or no hex colour attribute corresponding to the specified colour parameter value exists, the default fill colour will be used.

````
{
	"layout":"odd-r",
	"hexes": {
		"Q0R0":{"q":0,"r":0, "col":"red"},
		"Q1R1":{"q":1,"r":1 },
		"Q1R2":{"q":1,"r":2, "col":"blue"},
		"Q2R3":{"q":2,"r":3, "col":"red"}
	}
}
````

You can specify a hex attribute to be used to set the set label of each hex (default: `label`):  `hexjsonwidget(jsonbase="example-grid.hexjson", label='label')`. If there is no hex parameter of that name, the hex ID will be used as the label. Setting `labels=NA`  will turn off the labels.

Several hexjson files are bundled as part of the package. List the available hexjson files using the command: `hexjsonbasefiles()`

You can generate a map based on one of the base files by passing the base hexjson filename as the value for the `jsonbase` parameter: `hexjsonwidget(jsonbase="example-grid.hexjson")`

You can annotate a hexJSON file with data from a dataframe. The dataframe needs an ID column that can be used to match hexJSON hex key values. The default column expected for this purpose is `id`, but you can change it using the `keyid` parameter:

````
df=data.frame(id=c("Q0R0","Q1R2"), colour=c('orange','#ffddbb'), label=c('','test a'))
hexjsonwidget(jsonbase="example-grid.hexjson", data=df)
````

Data from each row of the dataframe will be merged into the hexJSON hex with a key value corresponding to the value in the specified `id` column in the dataframe. (You do not need to specify a row in the dataframe for each hex.) Dataframe column names are used as the data attribute names in the hex. If a dataframe column name is the same as a hex attribute name, the original hex data for that attribute will be overwritten by the dataframe data.

A hexJSON object can be created from a dataframe using the `hexjsonfromdataframe()` function:

```
jdf=data.frame(id=c("Q0R0","Q1R1","Q1R2"), q=c(0,1,1),
               row=c(0,1,2), colour=c('yellow','#ddbb99','green'))
jjx=hexjsonfromdataframe(jdf, r='row', keyid='id')

#Use this in hexjsonwidget():
hexjsonwidget(jjx, colour='colour')
```

Specify the dataframe column name used to defined each hex row parameter (`r`: default `r`) and column (`q`: default `q`).

To save the hexjson to a file, use `hexjsonwrite(df, filename)` and to read a json/hexjson file into a hexjson object use `hexjsonread(filename)`.


Alternatively, create the *hexjsonwidget* directly from the dataframe:

```
hexjsonwidget(fromdataframe=jdf, r='row', keyid='key', colour='colour')
```

### Blog Posts About the Creation of This Package

- [HexJSON HTMLWidget for R, Part 1](https://blog.ouseful.info/2017/06/28/hexjson-htmlwidget-for-r-part-1/)
- [HexJSON HTMLWidget for R, Part 2](https://blog.ouseful.info/2017/06/29/hexjson-htmlwidget-for-r-part-2/)
- [HexJSON HTMLWidget for R, Part 3](https://blog.ouseful.info/2017/06/30/hexjson-htmlwidget-for-r-part-3/)



