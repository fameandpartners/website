var Roles = React.createClass({
  propTypes: {
    current_user: React.PropTypes.object,
    onChange: React.PropTypes.func,
    roles_path: React.PropTypes.string,
    roles: React.PropTypes.array
  },

  getInitialState: function() {
    return {
      roles: ['bride', 'bridesmaid', 'maid of honor', 'mother of bride']
    };
  },

  componentWillMount: function() {
    this.generateRolesInput();
  },

  componentDidMount: function() {
    $(this.refs.select2).select2({
      minimumResultsForSearch: Infinity
    }).on('select2:select', function (evt) {
      this.props.onChange({ target: this.refs.select2 });
    }.bind(this));

  },

  generateRolesInput: function(roles) {
    var that = this;
    var options = this.state.roles.map(function(role, index) {
      var props = {
        key: 'wedding-roles-' + index,
        value: role
      };

      var label = role[0].toUpperCase() + role.slice(1);


      return (
        <option {...props}>{label}</option>
      );
    });

    this.setState({roles: options});
  },

  render: function() {
    return (
      <select
        ref="select2"
        name="role"
        onChange={this.props.onChange}
        defaultValue={this.props.current_user.role}>
        {this.state.roles}
      </select>
    );
  }
});
