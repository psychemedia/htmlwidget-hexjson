#' @title An htmlwidget for rendering hexjson maps using d3-hexjson
#'
#' @description \code{hexjsonwidget()} accepts a hexJSON object or path to a hexjson file and render it as an HTMLwidget using d3-hexjson.
#' 
#' @details
#' If a hexJSON hexobject includes a \code{col} attribute, this will be used to colour the hex.
#' If it contains a \code{label} attribute, it will be used to label the hex.
#' 
#' @name hexjsonwidget
#' @author Tony Hirst (@@psychemedia)
#'
#' @import htmlwidgets
#' @import jsonlite
#'
#' @param jsondata hexJSON object
#' @param jsonpath Path to hexJSON file
#' @param jsonbase Name of bundled hexJSON file
#' @param data Dataframe containing data to merge with hexjson file
#' @param dataid Name of data column for ID info
#' @param datacolour Name of data column for colour info
#' @param datalabel Name of data column for label info
#' @param grid Display a background grid in whitespace (either \code{on} or \code{off} (default)).
#' @param labels Enable/Disable lables (either \code{on} (default) or \code{off})
#' @param col_hexfill Fill colour for data hex if "col" hex value not set
#' @param col_gridfill Fill colour for grid hex 
#' @param col_textfill Fill colour for hex text label
#' @param width Widget width
#' @param height Widget height
#' @param elementId Widget element ID
#' 
#' @examples
#' hexjsonwidget( fromJSON('./example.hexjson') )
#' hexjsonwidget(jsonpath='./example-grid.hexjson')
#' hexjsonwidget(jj, grid='on', col_gridfill='#113355', col_hexfill='#FF0000')
#' hexjsonwidget(jj, grid='off', col_textfill="orange")
#' hexjsonwidget(jj, col_hexfill='#bb3388')
#' 
#' @export
hexjsonwidget <- function(jsondata=NA, jsonpath=NA, jsonbase=NA,
                          data=NA, dataid='id', datacolour='col', datalabel='label',
                          grid='off', labels="on", missinglabel=NA,
                          col_gridfill='', col_hexfill='', col_textfill='',
                          width = NULL, height = NULL, elementId = NULL) {

  if (identical(jsondata, NA)) {
    if  (identical(jsonpath, NA) && identical(jsonbase, NA)) {
      stop("Either 'jsondata', 'jsonpath' or 'jsonbase' must be set")
    } else if (identical(jsonbase, NA)) {
      jsondata=fromJSON(jsonpath)
    } else { 
      #Adding data to packages - http://r-pkgs.had.co.nz/data.html
      jsonpath=system.file("extdata", jsonbase, package = "hexjsonwidget")
      jsondata=fromJSON(jsonpath)
    }
  }
  
  if (!is.na(data)) {
    jsondata = hexjsondatamerge(jsondata, data, dataid, datacolour, datalabel )
  }
  
  # forward options using x
  x = list(
    jsondata = jsondata,
    grid = grid,
    labels = labels,
    missinglabel = missinglabel,
    # Colour parameters
    # Colour in a hex col attribute is used if available
    col_hexfill = col_hexfill,
    col_gridfill = col_gridfill,
    col_textfill = col_textfill
  )

  # create widget
  htmlwidgets::createWidget(
    name = 'hexjsonwidget',
    x,
    width = width,
    height = height,
    package = 'hexjsonwidget',
    elementId = elementId
  )
}

#' Annotate a hexjson file
#' 
#' @name hexjsonwidget
#' @author Tony Hirst (@@psychemedia)
#'
#' @import rlist
#' 
#' @param jsondata hexJSON object 
#' @param customdata Dataframe containing data to merge with hexjson file
#' @param dataid Name of \code{customdata} column for ID info
#' @param datacolour Name of \code{customdata} column for colour info
#' @param datalabel Name of \code{customdata} column for label info
#' @export
hexjsondatamerge <- function(jsondata, customdata,
                             dataid='id', datacolour='col', datalabel='label' ) {

  colnames(customdata)[colnames(customdata) == dataid] = 'id'
  colnames(customdata)[colnames(customdata) == datacolour] = 'col'
  colnames(customdata)[colnames(customdata) == datalabel] = 'label'
  rownames(customdata) = customdata[[dataid]]
  customdata[[dataid]] = NULL
  
  ll=lapply(split(customdata, rownames(customdata)), as.list)
  jsondata$hexes = list.merge(jsondata$hexes, ll)
  jsondata
}


#' List base hexjson files
#'
#' \code{hexjsonbasefiles} lists the hexjson files available as part of the package.
#' 
#' The files are stored in the \code{extdata/} directory in the package (\code{inst/extadata} in the original source code).
#' 
#' To use one of the base files, pass the filename as the \code{jsonbase} parameter value when calling \code{hexjsonwidget}.
#' 
#' @name hexjsonbasefiles
#' 
#' @export
hexjsonbasefiles <- function(){
  list.files(system.file("extdata", package = "hexjsonwidget"))
}


#' Shiny bindings for hexjsonwidget
#'
#' Output and render functions for using hexjsonwidget within Shiny
#' applications and interactive Rmd documents.
#'
#' @param outputId output variable to read from
#' @param width,height Must be a valid CSS unit (like \code{'100\%'},
#'   \code{'400px'}, \code{'auto'}) or a number, which will be coerced to a
#'   string and have \code{'px'} appended.
#' @param expr An expression that generates a hexjsonwidget
#' @param env The environment in which to evaluate \code{expr}.
#' @param quoted Is \code{expr} a quoted expression (with \code{quote()})? This
#'   is useful if you want to save an expression in a variable.
#'
#' @name hexjsonwidget-shiny
#'
#' @export
hexjsonwidgetOutput <- function(outputId, width = '100%', height = '400px'){
  htmlwidgets::shinyWidgetOutput(outputId, 'hexjsonwidget', width, height, package = 'hexjsonwidget')
}

#' @rdname hexjsonwidget-shiny
#' @export
renderHexjsonwidget <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) { expr <- substitute(expr) } # force quoted
  htmlwidgets::shinyRenderWidget(expr, hexjsonwidgetOutput, env, quoted = TRUE)
}
