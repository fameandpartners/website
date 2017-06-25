var TutorialStep1 = React.createClass({
  render: function() {
    return (
      <div className='text-center'>
        <div className='tutorial__step'>
          <i className='icon icon-silhouette'></i>
          <br/>
          <span>STEP 1</span>
        </div>
        <h1 className='text-center'>Customize your dress</h1>
        <p className='tutorial__description'>It's up to you! Choose your silhouette, fabric, length, style, and fit.</p>
        <input className="btn btn-black full-width" name="commit" defaultValue="next" onClick={this.props.nextStep} />
      </div>
    );
  }
});
