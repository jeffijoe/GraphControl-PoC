(function(window, $) {
  var MAX_VALUES = 1000;
  var Graph = {
    initialize: function() {
      this.$canvas = $('#graph');
      this.canvas = this.$canvas[0];
      this.width = window.innerWidth;
      this.height = window.innerHeight;
      this.canvas.width = this.width;
      this.canvas.height = this.height;
      this.ctx = this.canvas.getContext('2d');
      this.value = 255;
      this.values = [];
      $(window).on('resize', this.onWindowResize.bind(this));
    },
    onWindowResize: function () {
      this.canvas.width = this.width = window.innerWidth;
      this.canvas.height = this.height = window.innerHeight;
    },
    receive: function(value) {
      this.value = value;
    },
    update: function(time) {
      if(this.values.length > MAX_VALUES)
        this.values.splice(MAX_VALUES, 99999);
      this.values.splice(0, 0, this.value);
    },
    draw: function(time) {
      this.ctx.clearRect(0, 0, this.ctx.canvas.width, this.ctx.canvas.height);

      this.ctx.beginPath();
      this.ctx.lineWidth = 15;
      this.ctx.strokeStyle = '#03A9F4';

      var i = 0;
      this.values.forEach(function (value) {
        this.ctx.lineTo(this.width-i++, this.getActualPosition(value));
      }.bind(this));

      this.ctx.stroke();
    },
    getActualPosition: function(value) {
      return (value / 255) * this.height;
    }
  };

  Graph.initialize();
  var time = {
    ellapsed: 0,
    delta: 0
  };
  (function animLoop(ellapsed) {
    window.requestAnimationFrame(animLoop);
    time.delta = ellapsed - time.ellapsed;
    time.ellapsed = ellapsed;
    Graph.update(time);
    Graph.draw(time);
  }());

  window.Graph = Graph;
}(window, jQuery));