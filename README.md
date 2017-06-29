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
hexjsonwidget(jj,grid='on')
````
