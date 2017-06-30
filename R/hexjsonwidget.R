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
#' @param fromdataframe Dataframe to be used to create a hexJSON file
#' @param data Dataframe containing data to merge with hexjson file
#' @param keyid Name of data column for ID info
#' @param colour Name of the hex attribute used to set the hex colour; set to \code{NA} to use the default.
#' @param label Name of the hex attribute used to set the hex label; set to \code{NA} to turn labels off.
#' @param missinglabel Value to use for missing label; if set to \code{NA} (default), use hex id. If \code{label} is set to a non-existing hex atribute, and \code{missinglabel} is set to \code{NA}, the hex key will be displayed as the label in each hex. 
#' @param grid Display a background grid in whitespace (either \code{on} or \code{off} (default)).
#' @param col_hexfill Default fill colour for data hex if "col" hex value not set
#' @param col_gridfill Default fill colour for grid hex 
#' @param col_textfill Default fill colour for hex text label
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
#' hexjsonwidget(jj, grid='off', col_textfill="orange",colour=NA)
#' 
#' df=data.frame(id=c("Q0R0","Q1R2"),colour=c('orange','#ffddbb'),label=c('','test a'))
#' hexjsonwidget(jsonbase="example-grid.hexjson",data=df,colour='colour')
#' 
#' jdf=data.frame(id=c("Q0R0","Q1R1","Q1R2"),q=c(0,1,1),
#' row=c(0,1,2), colour=c('yellow','#ddbb99','green'))
#' jjx=hexjsonfromdataframe(jdf,r='row', keyid='id')
#' hexjsonwidget(jjx, colour='colour')
#' 
#' @return an HTMLwidget object
#' @export
hexjsonwidget <- function(jsondata=NA, jsonpath=NA, jsonbase=NA, fromdataframe=NA,
                          data=NA, keyid='id', colour='col', label='label',
                          layout='odd-r', row='r', column='q',
                          grid='off', labels="on", missinglabel=NA,
                          col_gridfill="#f0f0f0", col_hexfill="#b0e8f0", col_textfill="#000000",
                          width = NULL, height = NULL, elementId = NULL) {

  if (!(identical(jsondata, NA))) {
    jsondata=jsondata
  } else if (!(identical(jsonpath, NA))) {
    jsondata=fromJSON(jsonpath)
  } else if (!(identical(jsonbase,NA))) { 
    #Adding data to packages - http://r-pkgs.had.co.nz/data.html
    jsonpath=system.file("extdata", jsonbase, package = "hexjsonwidget")
    jsondata=fromJSON(jsonpath)
  } else if (!(identical(fromdataframe,NA))) {
    jsondata=hexjsonfromdataframe(fromdataframe,
                                  layout=layout, keyid=keyid, q=column,r=row)
  } else {
    stop("One of 'jsondata', 'jsonpath', 'jsonbase' or 'fromdataframe' must be set")
  }
  
  if (!identical(data,NA)) {
    jsondata = hexjsondatamerge(jsondata, data, keyid )
  }
  
  # forward options using x
  x = list(
    jsondata = jsondata,
    grid = grid,
    missinglabel = missinglabel,
    # Colour parameters
    colour_attr=colour,
    label_attr=label,
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
#' @name hexjsondatamerge
#' @author Tony Hirst (@@psychemedia)
#'
#' @import rlist
#' 
#' @param jsondata hexJSON object 
#' @param customdata Dataframe containing data to merge with hexjson file
#' @param keyid Name of \code{customdata} column for ID info
#' @return a hexjson (JSON) object
#' @export
hexjsondatamerge <- function(jsondata, customdata,
                             keyid='id' ) {

  colnames(customdata)[colnames(customdata) == keyid] = 'id'
  rownames(customdata) = customdata[[keyid]]
  customdata[[keyid]] = NULL
  
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

#' Create a hexjson file from a dataframe
#' 
#' @name hexjsonfromdataframe
#' @author Tony Hirst (@@psychemedia)
#' 
#' @import jsonlite
#' 
#' @param df Dataframe to convert to hexjson
#' @param layout Can be one of \code{odd-r} (pointy-topped, default), \code{even-r} (pointy-topped), \code{odd-q} (flat-topped), \code{even-q} (flat-topped).
#' @param keyid The column specifying the hex identifier/key (default is \code{id}).
#' @param q The column specifying the hexJSON columns (default is \code{q}).
#' @param r The column specifying the hexJSON rows (default is \code{r}).
#' @return a hexjson (JSON) object
#' @export
hexjsonfromdataframe <- function(df,layout="odd-r",keyid='id',
                                 q='q', r='r'){
  
  rownames(df) = df[[keyid]]
  df[[keyid]] = NULL
  colnames(df)[colnames(df) == q] = 'q'
  colnames(df)[colnames(df) == r] = 'r'
  
  list(layout=layout,
       hexes=lapply(split(df, rownames(df)), as.list))
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
#' @return
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
