var TutorialStep3 = React.createClass({
  nextStep: function(e) {
    e.preventDefault();

    this.props.finishTutorial();
  },

  render: function() {
    return (
      <div className='text-center'>
        <div className='tutorial__step'>
          <i className='icon icon-silhouette'></i>
          <br/>
          <span>STEP 3</span>
        </div>
        <h1 className='text-center'>Start the conversation</h1>
        <p className='tutorial__description'>Chat about the dresses with your bridesmaids. Even enlist the help of one of our Fame stylists (for FREE!)</p>
        <input className="btn btn-black full-width" name="commit" defaultValue="Done" onClick={this.nextStep} />
      </div>
    );
  }
});
