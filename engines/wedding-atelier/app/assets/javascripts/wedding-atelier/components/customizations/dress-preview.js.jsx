var DressPreview = React.createClass({
  propTypes: {
    selectedOptions: React.PropTypes.object
  },

  componentDidMount: function() {
    $(this.refs.panzoom).panzoom({
      $zoomIn:            $(this.refs.zoomin),
      $zoomOut:           $(this.refs.zoomout),
      $reset:             $(this.refs.reset),
      increment:          0.1,
      which:              1,
      minScale:           1,
      disablePan:         false,
      panOnlyWhenZoomed:  true
    });
  },

  render: function() {
    return (
      <div className="dress-preview">
        <div className="preview panzoom-parent">
          <img ref="panzoom"  src="/assets/wedding-atelier/customization_experience/dress_preview.png"/>
        </div>
        <div className="controls">
          <div ref="zoomin" className="zoom in">
            <span>+</span>
          </div>
          <div ref="zoomout" className="zoom out">
            <span>-</span>
          </div>
          <div ref="reset" className="zoom reset">
            <a>Reset</a>
          </div>
          <div>
            <a href="#">Details</a>
          </div>

        </div>
      </div>
    );
  }
});
