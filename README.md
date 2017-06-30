# htmlwidget-hexjson

Simple R/htmlwidget for displaying hexjson maps based on Oli Hawkins' [d3-hexjson](https://github.com/olihawkins/d3-hexjson) package,  a D3 module for generating hexmaps from data in the Open Data Institute's [HexJSON format](https://odileeds.org/projects/hexmaps/hexjson.html).

Download and unzip the folder, cd into it and install with: `devtools::install()` or install directly from Github:

    library(devtools)
    install_github("psychemedia/htmlwidget-hexjson")

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

You can also add a `col` attribute to hexes in the hexJSON file. If no `col` is specified, the default fill colour will be used.

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

If a hexJSON hex has a `label` attribute, this will be used to label the hex, otherwise the hex ID will be used as the label. Passing `labels="off"` to `hexjsonwidget()` will turn off labels (default is `"on"`).

Several hexjson files are bundled as part of the package. List the available hexjson files using the command: `hexjsonbasefiles()`

You can generate a map based on one of the base files by passing the base hexjson filename as the value for the `jsonbase` parameter: `hexjsonwidget(jsonbase="example-grid.hexjson")`

You can annotate a hexJSON file with data from a dataframe. The dataframe needs an ID column that can be used to match hexJSON hex key values. The default column expected for this purpose is `id`, but you can change it using the `dataid` parameter. Distinguished column names for hex colour (default: `col`) and hex label (default: `label`) can also be specified using the `datacolour` and `datalabel` parameters respectively:

````
df=data.frame(id=c("Q0R0","Q1R2"),colour=c('orange','#ffddbb'),label=c('','test a'))
hexjsonwidget(jsonbase="example-grid.hexjson",data=df,datacolour='colour')
````

Data from each row of the dataframe will be merged into the hexJSON hex with a key value corresponding to the value in the specified `id` column in the dataframe. (You do not need to specify a row in the dataframe for each hex.) Dataframe column names are used as the data attribute names in the hex. If a dataframe column name is the same as a hex attribute name, the original hex data for that attribute will be overwritten by the dataframe data.
