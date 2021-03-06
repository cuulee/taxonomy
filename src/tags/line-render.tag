<line-render>
  <h2>{ this.opts.title }</h2>
  <div class="render-container">
    <div class="render-column" each="{ zoom in this.opts.zooms }">
    <span class="render-header">{ zoom }</span>
      <div if="{ this.lines }" each="{ line in this.lines }" class="render-item" style="min-height: { this.getMinHeight(line) }px;">
      <canvas style="width: 55px; height: { line[zoom].width }px; background-color: { line[zoom].color }; {taxonomy.borderStyleFromCasing(this.casing[line.id], line, zoom)} opacity: { line[zoom].opacity };"></canvas>
      </div>
    </div>
    <div class="render-column">
      <span class="render-header">id</span>
      <div if="{ this.lines }" each="{ line in this.lines }" class="render-item" style="min-height: { this.getMinHeight(line) }px;">
        { line.id }
      </div>
    </div>
  </div>
  <script type="text/javascript">
    const self = this;
    this.casing = {};
    this.lines = this.opts.layers.filter(function(layer) {
      if (layer.metadata && layer.metadata['taxonomy:group'] === self.opts.group && (layer.type == 'line' || layer.ref)) {
        if (!layer.metadata['taxonomy:casing'] && !layer.ref) {
          return true;
        }
        self.casing[layer.metadata['taxonomy:casing'] || layer.ref] = layer;
      }
      return false;
    }).map(function(layer) {
      if (self.casing[layer.id]) {
        self.casing[layer.id] = taxonomy.renderLine(self.casing[layer.id], self.opts.zooms);
      }
      return taxonomy.renderLine(layer, self.opts.zooms);
    });
    this.getMinHeight = function(line) {
      const res = 12 + line.maxWidth + (this.casing[line.id] ? this.casing[line.id].maxWidth : 0);
      return res > 25 ? res : 25;
    }
  </script>
</line-render>