var TutorialStep2 = React.createClass({
  render: function() {
    return (
      <div className='text-center'>
        <div className='tutorial__step'>
          <i className='icon icon-style'></i>
          <br/>
          <span>STEP 2</span>
        </div>
        <h1 className='text-center'>Save your dress to your board</h1>
        <p className='tutorial__description'>Save your creation to your board so you can share with bridesmaids and friends.</p>
        <input className="btn btn-black full-width" name="commit" defaultValue="next" onClick={this.props.nextStep} />
      </div>
    );
  }
});
