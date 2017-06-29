#' An htmlwidget for rendering hexjson maps using d3-hexjson
#'
#' \code{hexjsonwidget} accepts a hexJSON object or path to a hexjson file and render it as an HTMLwidget using d3-hexjson.
#' 
#' @name hexjsonwidget
#' @docType package
#' @author Tony Hirst (@@psychemedia)
#'
#' @import htmlwidgets
#' @import jsonlite
#'
#' @param jsondata hexJSON object
#' @param jsonpath Path to hexJSON file
#' @param grid Display a background grid in whitespace (either \code{on} or \code{off} (default)).
#' @param col_hexfill Fill colour for data hex if "col" hex value not set
#' @param col_gridfill Fill colour for grid hex 
#' @param col_textfill Fill colour for hex text label
#' @param width 
#' @param height
#' @param elementId 
#' 
#' @export
hexjsonwidget <- function(jsondata=NA, jsonpath=NA, grid='off',
                          col_hexfill='', col_gridfill='', col_textfill='',
                          width = NULL, height = NULL, elementId = NULL) {

  if (identical(jsondata, NA)) {
    if  (identical(jsonpath, NA)) {
      stop("Either 'jsondata' or 'jsonpath' must be set")
    } else {
      jsondata=fromJSON(jsonpath)
    }
  }
  
  # forward options using x
  x = list(
    jsondata = jsondata,
    grid = grid,
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
