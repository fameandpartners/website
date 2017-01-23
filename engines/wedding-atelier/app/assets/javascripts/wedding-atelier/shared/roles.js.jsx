var Roles = React.createClass({

  propTypes: {
    roles: React.PropTypes.array,
    roles_path: React.PropTypes.string,
    current_user: React.PropTypes.object,
    onChange: React.PropTypes.func
  },

  getInitialState: function() {
    return {
      roles: ['bridesmaid', 'maid of honor', 'mother of bride', 'bride']
    }
  },

  componentWillMount: function() {
    this.generateRolesInput();
  },

  componentDidMount: function() {
    $(this.refs.select2).select2({
      minimumResultsForSearch: Infinity
    }).on('select2:select', function (evt) {
      this.props.onChange({ target: this.refs.select2 })
    }.bind(this));

  },

  generateRolesInput: function(roles) {
    var that = this;
    var options = this.state.roles.map(function(role, index){
      var props = {
        key: index,
        value: role
      }
      if(role == that.props.current_user.role){
        props.selected = true;
      }
      return (<option {...props}>{role}</option>);
    });

    this.setState({roles: options});
  },

  render: function() {
    return (<select
      ref="select2"
      name="role"
      onChange={this.props.onChange}>
      {this.state.roles}
      </select>);
  }

});
