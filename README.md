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

You can also add a `col` attribute to the hexJSON file. If no `col` is specified, the default fill colour will be used.

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

