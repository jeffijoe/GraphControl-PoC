/**
 * Graph object. Using HTML5 Canvas and requestAnimationFrame.
 */
(function(window, $) {
  // How many values do we want to save?
  var MAX_VALUES = 1000;
  // Offset from the right of the screen.
  var GRAPH_RIGHT_OFFSET = 500;

  // The graph line width.
  var LINE_WIDTH = 10;

  // Line color.
  var LINE_COLOR = '#259a17';

  // Graph object.
  var Graph = {
    /**
     * Initializes the object.
     */
    initialize: function() {
      this.$canvas = $('#graph');
      this.canvas = this.$canvas[0];
      this.onWindowResize();
      this.ctx = this.canvas.getContext('2d');
      this.value = 255;
      this.values = [];
      $(window).on('resize', this.onWindowResize.bind(this));
      this.setupDrawingProperties();
    },
    /**
     * Colors, size and stuff.
     */
    setupDrawingProperties: function() {
      this.ctx.lineWidth = LINE_WIDTH;
      this.ctx.strokeStyle = LINE_COLOR;
      this.ctx.shadowBlur = 20;
      this.ctx.shadowColor = LINE_COLOR;
    },
    /**
     * Resizes the canvas.
     */
    onWindowResize: function() {
      this.canvas.width = this.width = window.innerWidth;
      this.canvas.height = this.height = window.innerHeight;
      this.posX = (this.width / 2) + GRAPH_RIGHT_OFFSET;
    },
    /**
     * Called when the server has a new value.
     */
    receive: function(value) {
      this.value = value;
    },
    /**
     * Update loop - adds the last saved value to our values array.
     * Also trims the end of the array when appropriate.
     */
    update: function() {
      if (this.values.length > MAX_VALUES)
        this.values.splice(MAX_VALUES, 99999);
      this.values.splice(0, 0, this.value);
    },
    /**
     * Draw loop.
     */
    draw: function() {
      // Clear the canvas.
      this.ctx.clearRect(0, 0, this.ctx.canvas.width, this.ctx.canvas.height);

      // Start drawing.
      this.ctx.beginPath();

      var i = 0;
      this.values.forEach(function(value) {
        var posY = this.getActualPosition(value);
        // Offset by the current iteration number.
        // This is what is "pushing" the previous values to the left.
        var posX = this.posX - i++;
        this.ctx.lineTo(posX, posY);
      }.bind(this));

      // Finish the line.
      this.ctx.stroke();
    },
    /**
     * Calculates the position of the line
     * based on the screen size.
     */
    getActualPosition: function(value) {
      return (value / 255) * this.height;
    }
  };
  // Initialize.
  Graph.initialize();

  // Animation loop.
  (function animLoop(ellapsed) {
    window.requestAnimationFrame(animLoop);
    Graph.update();
    Graph.draw();
  }());

  window.Graph = Graph;
}(window, jQuery));
