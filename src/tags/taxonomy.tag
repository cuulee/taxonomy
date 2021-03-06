<taxonomy>
  <div if="{ this.style && this.style.metadata }" class="container" ref="container">
    <div if="{ this.style.metadata['taxonomy:title'] }" class="taxonomy-item">
      <h1>{ this.style.metadata['taxonomy:title'] }</h1>
    </div>
    <div class="taxonomy-item" each="{ group in this.style.metadata['taxonomy:groups'] }">
      <line-render if="{ group.type === 'line' }" layers="{this.style.layers}" title="{ group.title }" group="{ group.id }" zooms="{ taxonomy.getZooms(group.zooms) }"></line-render>
      <polygon-render if="{ group.type === 'polygon' }" layers="{this.style.layers}" title="{ group.title }" group="{ group.id }" zooms="{ taxonomy.getZooms(group.zooms) }"></polygon-render>
      <symbol-render if="{ group.type === 'symbol' }" layers="{this.style.layers}" title="{ group.title }" group="{ group.id }" zooms="{ taxonomy.getZooms(group.zooms) }"></symbol-render>
      <annotation if="{ group.type === 'annotation' }" layers="{this.style.layers}" content="{ group.content }" group="{ group.id }" zooms="{ taxonomy.getZooms(group.zooms) }"></annotation>
    </div>
    <div style='font-size: 12px; text-align: center;'>Powered by <a href='https://www.jawg.io/'>Jawg<span style='color: #2999fd;'>Maps</span></a>.
      Contribute on <a href='https://github.com/jawg/taxonomy/'>GitHub</a>.
  </div>
  <script type="text/javascript">
    this.fetchStyleURL = function (callback) {
      var req = new XMLHttpRequest();
      req.addEventListener('load', function () {
        switch (this.status) {
          case 200:
            return callback(null, JSON.parse(this.responseText));
          case 400:
            return callback('You sent a bad request.');
          case 401:
            return callback('You are not authorized to use this geocode.');
          case 500:
            return callback('This server can not answer yet.');
        }
      });
      req.open('GET', this.opts.styleUrl);
      req.send();
    };

    this.setBackgroundColor = function () {
      var layers = this.style.layers;
      for (var i in layers) {
        if (layers[i].type === 'background') {
          this.refs['container'].style['background-color'] = layers[i].paint['background-color'] || '#fff';
          return;
        }
      }
    };

    this.one('mount', function () {
      var self = this;
      if (!this.opts.styleUrl) {
        return console.error('Style URL is missing');
      }
      this.fetchStyleURL(function (err, res) {
        if (err) {
          return console.error('Error in fetch style');
        }
        self.style = res;
        self.update();
      });
    });

    this.on('updated', function() {
      this.setBackgroundColor();
      taxonomy.fonts.download();
    });
  </script>
</taxonomy>