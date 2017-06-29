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
        		
    var hexbinding="g"
    
    return {

      renderValue: function(x) {

          hexjson = x.jsondata;

        	// Render the hexes
        	var hexes = d3.renderHexJSON(hexjson, width, height);

          // colour maps - should these be handled by CSS?
          var col_hexfill="#b0e8f0";
          var col_gridfill="#f0f0f0";
          var col_textfill="#000000";
          
          if (x.col_hexfill !=="") col_hexfill = x.col_hexfill;
          if (x.col_gridfill !== "") col_gridfill = x.col_gridfill;
          if (x.col_textfill !== "") col_textfill = x.col_textfill;
          
          if (x.grid == "on") {
            
            hexbinding="g.data"
            
            // Create the grid hexes and render them
          	var grid = d3.getGridForHexJSON(hexjson);
          	var gridHexes = d3.renderHexJSON(grid, width, height);
            
          	// Draw the background grid BEFORE the data
          
          	// Bind the grid hexes to g.grid elements of the svg and position them
          	var hexgrid = svg
          		.selectAll("g.grid")
          		.data(gridHexes)
          		.enter()
          		.append("g")
          		.attr("transform", function(hex) {
          			return "translate(" + hex.x + "," + hex.y + ")";
          		});
          
          	// Draw the polygons around each grid hex's centre
          	hexgrid
          		.append("polygon")
          		.attr("points", function(hex) {return hex.points;})
          		.attr("stroke", "#b0b0b0")
          		.attr("stroke-width", "1")
          		.attr("fill", col_gridfill);
          }

        	// Bind the hexes to g elements of the svg and position them
        	var hexmap = svg
        		.selectAll(hexbinding)
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
        		.attr("fill",function(hex) {
        		  return hex.hasOwnProperty("col") && hex.col!=="" ? hex.col : col_hexfill;
        		});
        		//.attr("fill", col_hexfill);
        
        	// Add the hex codes as labels
        	hexmap
        		.append("text")
        		.append("tspan")
        		.attr("text-anchor", "middle")
        		.attr("fill", col_textfill)
        		.text(function(hex) {return hex.key;});

      },

      resize: function(width, height) {

        // TODO: code to re-render the widget with a new size

      }
    };
  }
});