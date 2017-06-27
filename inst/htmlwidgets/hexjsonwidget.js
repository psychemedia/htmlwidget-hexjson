HTMLWidgets.widget({

  name: 'hexjsonwidget',

  type: 'output',

  factory: function(el, width, height) {

    var margin = {top: 10, right: 10, bottom: 10, left: 10},
    		width = 500 - margin.left - margin.right,
    		height = 420 - margin.top - margin.bottom;
    		
    // Create the svg element
    var svg = d3
        		.select("#"+el.id)
        		.append("svg")
        		.attr("width", width + margin.left + margin.right)
        		.attr("height", height + margin.top + margin.bottom)
        		.append("g")
        		.attr("transform", "translate(" + margin.left + "," + margin.top + ")");

    return {

      renderValue: function(x) {

          hexjson = x.jsondata;

        	// Render the hexes
        	var hexes = d3.renderHexJSON(hexjson, width, height);
         console.log(hexes);
        	// Bind the hexes to g elements of the svg and position them
        	var hexmap = svg
        		.selectAll("g")
        		.data(hexes)
        		.enter()
        		.append("g")
        		.attr("transform", function(hex) {
        			return "translate(" + hex.x + "," + hex.y + ")";
        		});
        
        	// Draw the polygons around each hex's centre
        	hexmap
        		.append("polygon")
        		.attr("points", function(hex) {return hex.points;})
        		.attr("stroke", "white")
        		.attr("stroke-width", "2")
        		.attr("fill", "#b0e8f0");
        
        	// Add the hex codes as labels
        	hexmap
        		.append("text")
        		.append("tspan")
        		.attr("text-anchor", "middle")
        		.text(function(hex) {return hex.key;});

      },

      resize: function(width, height) {

        // TODO: code to re-render the widget with a new size

      }

    };
  }
});