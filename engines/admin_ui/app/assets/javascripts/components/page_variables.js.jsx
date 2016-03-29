var PageVariablesField = React.createClass({
    getInitialState: function () {
      return {
        id: this.props.id,
        variableValue: this.props.variableValue,
        variableKey: this.props.variableKey
      }
    },
    componentWillReceiveProps: function(nextProps) {
      this.setState({
        id: nextProps.id,
        variableValue: nextProps.variableValue,
        variableKey: nextProps.variableKey
      });
    },
    handleFieldUpdate: function () {
      this.props.handleFieldUpdate(this.state);
    },
    handleFieldRemove: function (e) {
      e.preventDefault();
      var self = this;
      return variables_confirm('Are you sure?', {
        description: 'Would you like to remove this variable?',
        confirmLabel: 'Yes',
        abortLabel: 'No'
      }).then((function(_this) {
        return function() {
          var variableKey = self.props.variableKey;
          self.props.handleFieldRemove(self.state);
        };
      })(this));
    },
    handleKeyChange: function (e) {
      this.setState({variableKey: e.target.value}, this.handleFieldUpdate);
    },

    handleValueChange: function (e) {
      this.setState({variableValue: e.target.value}, this.handleFieldUpdate);
    },
    render: function () {
        return (
            <div>
                <input type="text" name="page[variables][][key]" placeholder="Variable Key"
                  onChange={this.handleKeyChange} value={this.state.variableKey} />
                  &nbsp;
                <input type="text" name="page[variables][][value]" placeholder="Variable Value"
                  onChange={this.handleValueChange} value={this.state.variableValue} />
                  &nbsp;
                <button className="btn btn-danger btn-xs removable" onClick={this.handleFieldRemove}>Remove</button>
            </div>
        );
    }
});

var PageVariableList = React.createClass({
    render: function () {
      var self = this;
      return (
        <div>
          { self.props.variables.map(function (field, index) {
            return <PageVariablesField key={index} id={index}
              handleFieldUpdate={self.props.handleFieldUpdate} handleFieldRemove={self.props.handleFieldRemove}
              variableKey={field.variableKey} variableValue={field.variableValue} />
          })
        }
        </div>
      )
    }
});

var PageVariablesComponent = React.createClass({
    getInitialState: function () {
      return {variables: []};
    },
    componentDidMount: function () {
      var newVariables = [];
      for (var prop in this.props) {
          var field = { variableKey: prop, variableValue: this.props[prop] };
          newVariables.push(field);
      }
      this.setState({variables: newVariables});
    },
    handleFieldAdd: function (e) {
      e.preventDefault();
      var newVariables = this.state.variables.slice();
      newVariables.push({});
      this.setState({variables: newVariables});
    },
    handleFieldUpdate: function(variable) {
      var newVariables = this.state.variables;
      newVariables[variable.id] = {variableKey: variable.variableKey, variableValue: variable.variableValue};
      this.setState({variables: newVariables});
    },
    handleFieldRemove: function (variable) {
      var newVariables = this.state.variables;
      newVariables.splice(variable.id, 1);
      this.setState({variables: newVariables});
    },
    render: function () {
        return (
            <div>
                <PageVariableList variables={this.state.variables} handleFieldRemove={this.handleFieldRemove} handleFieldUpdate={this.handleFieldUpdate} />
                <button className="btn btn-primary btn-xs" onClick={this.handleFieldAdd}>Add</button>
            </div>
        );
    }
});

var variables_confirm = function(message, options) {
  var cleanup, component, props, wrapper;
  if (options == null) {
    options = {};
  }
  props = $.extend({
    message: message
  }, options);
  wrapper = document.body.appendChild(document.createElement('div'));
  component = React.render(<Confirm {...props}/>, wrapper);
  cleanup = function() {
    React.unmountComponentAtNode(wrapper);
    return setTimeout(function() {
      return wrapper.remove();
    });
  };
  return component.promise.always(cleanup).promise();
};
