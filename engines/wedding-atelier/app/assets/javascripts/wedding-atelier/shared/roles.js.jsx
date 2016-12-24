var Roles = React.createClass({

  propTypes: {
    roles: React.PropTypes.array,
    roles_path: React.PropTypes.string,
    onChange: React.PropTypes.func
  },

  getInitialState: function() {
    return {
      roles: [
        { id: 1, name: 'role 1'},
        { id: 2, name: 'role 2'},
        { id: 3, name: 'role 2'}
      ]
    }
  },

  componentWillMount: function() {
    // this.getRoles().then(function() {
      this.generateRolesInput();
    // });
  },

  componentDidMount: function() {

    $(this.refs.select2).select2({
      minimumResultsForSearch: Infinity
    }).on('select2:select', function (evt) {
      this.props.onChange({ target: this.refs.select2 })
    }.bind(this));

  },

  getRoles: function() {
    return $.ajax({
      url: "",
      success: function(roles){
        this.setState({roles: roles});
      }
    });
  },

  generateRolesInput: function(roles) {
    var options = this.state.roles.map(function(role, index){
      return (<option key={index} value={role.id}>{role.name}</option>);
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
