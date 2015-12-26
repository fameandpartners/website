//TODO: new fields will not have keys on the component variables array, causing a massive deletion if user click "remove" on recently created elements
// Example:
// User add a field (field 1)
// User another field (field 2)
// User edits key value from a field (field 1)
// User removes the empty field (field 2)
// All fields are removed! D=

var PageVariablesField = React.createClass({
    getInitialState: function () {
        return { variableValue: this.props.variableValue, variableKey: this.props.variableKey }
    },
    handleFieldRemove: function (e) {
        e.preventDefault();
        var variableKey = this.props.variableKey;
        this.props.handleFieldRemove(variableKey);
    },
    handleKeyChange: function (e) {
        this.setState({variableKey: e.target.value});
    },

    handleValueChange: function (e) {
        this.setState({variableValue: e.target.value});
    },
    render: function () {
        return (
            <div>
                <input type="text" name="page[variables][][key]" placeholder="Variable Key" onChange={this.handleKeyChange} value={this.state.variableKey} />
                <input type="text" name="page[variables][][value]" placeholder="Variable Value" onChange={this.handleValueChange} value={this.state.variableValue} />
                <button onClick={this.handleFieldRemove}>Remove</button>
            </div>
        );
    }
});

var PageVariableList = React.createClass({
    render: function () {
        var self = this;
        var variables = self.props.variables.map(function (field, index) {
            return (
                <PageVariablesField key={index} handleFieldRemove={self.props.handleFieldRemove} variableKey={field.variableKey} variableValue={field.variableValue} />
            );
        });

        return (
            <div>
                {variables}
            </div>
        );
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
    handleFieldRemove: function (variableKey) {
        var newVariables = this.state.variables.filter(function (variable) {
            return variable.variableKey != variableKey;
        });
        this.setState({variables: newVariables});
    },
    render: function () {
        return (
            <div>
                <PageVariableList variables={this.state.variables} handleFieldRemove={this.handleFieldRemove} />
                <button onClick={this.handleFieldAdd}>Add</button>
            </div>
        );
    }
});
