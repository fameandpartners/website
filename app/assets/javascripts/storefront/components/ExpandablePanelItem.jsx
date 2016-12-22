import React, {Component, PropTypes,} from 'react';

class ExpandablePanel extends Component {
    constructor(props) {
        super(props);
        this.state = {
            isActive: false,
        };

        this.openPanel = this.openPanel.bind(this);
    }

    openPanel() {
        this.setState({ isActive: !this.state.isActive, });
    }

    render() {
      const { itemGroup, isSecondaryFilter, revealedContent, } = this.props;
      const { isActive, } = this.state;
      return (
          <div className={`ExpandablePanelItem
            ${isActive ? 'ExpandablePanelItem--is-active' : ''}
            ${isSecondaryFilter ? 'ExpandablePanelItem--secondary' : ''}
          `}>
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
    revealedContent: PropTypes.node,
};

export default ExpandablePanel;
