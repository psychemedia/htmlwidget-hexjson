#' <Add Title>
#'
#' <Add Description>
#'
#' @import htmlwidgets
#'
#' @export
hexjsonwidget <- function(jsondata, width = NULL, height = NULL, elementId = NULL) {

  # forward options using x
  x = list(
    jsondata = jsondata
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
