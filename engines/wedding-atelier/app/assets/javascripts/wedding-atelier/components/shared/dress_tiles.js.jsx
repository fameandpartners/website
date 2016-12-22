var DressTiles = React.createClass({

  propTypes: {
    dresses: React.PropTypes.array
  },

  getInitialState: function(){
    return {dresses: []}
  },

  componentDidMount: function(){

    this.setState({dresses: [

      {
        title: 'test',
        image: 'https://s-media-cache-ak0.pinimg.com/736x/5e/f3/f1/5ef3f10a3d464c28fc2a3711195b700d.jpg',
        author: 'Trino',
        price: '3.45'
      },
      {
        title: 'test',
        image: 'https://s-media-cache-ak0.pinimg.com/564x/43/17/15/4317155ad1cce7d6b36e42ed53a1413b.jpg',
        author: 'Trino',
        price: '3.45'
      },
      {
        title: 'test',
        image: 'https://s-media-cache-ak0.pinimg.com/originals/67/e6/ea/67e6ea8103b45da806865143d55ddad3.jpg',
        author: 'Trino',
        price: '3.45'
      },
      {
        title: 'test',
        image: 'https://s-media-cache-ak0.pinimg.com/736x/24/c2/70/24c270867a71b90b76500397ce5fbfb3.jpg',
        author: 'Trino',
        price: '3.45'
      },
      {
        title: 'test',
        image: 'http://www.bookeveningdress.com/wp-content/uploads/2016/05/sexy-wedding-dresses-for-sale-with-keyword.jpg',
        author: 'Trino',
        price: '3.45'
      }

    ]})

    // this.setState({dresses: this.props.dresses})
  },

  render: function() {
    var content = this.state.dresses.map(function(dress) {
      return(<DressTile dress={dress} />)
    });
    return(<div className='dress-boxes'> {content} </div>)
  }
})
