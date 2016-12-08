import React, {Component, PropTypes} from 'react';

class ExpandablePanel extends Component {
    constructor(props) {
        super(props);
        this.state = {
            isOpen: false
        };

        this.openPanel = this.openPanel.bind(this);
    }

    openPanel() {
        this.setState({ isOpen: !this.state.isOpen });
    }

    render() {
      const { itemGroup, revealedContent } = this.props;
      const { isOpen } = this.state;
      return (
          <div className={`ExpandablePanelItem ${isOpen ? 'isOpen' : ''}`}>
              <div className="ExpandablePanelItem__item-bar" onClick={this.openPanel}>
                  {itemGroup}
              </div>
              <div className="ExpandablePanelItem__revealed-content">
                  {revealedContent}
              </div>
          </div>
      );
    }
}

ExpandablePanel.propTypes = {
    itemGroup: PropTypes.node,
    revealedContent: PropTypes.node
};

export default ExpandablePanel;
