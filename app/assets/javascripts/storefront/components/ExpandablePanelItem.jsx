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
        const newActiveState = !this.state.isActive;
        this.setState({ isActive: newActiveState, });
        if (typeof this.props.openPanelCallback === 'function'){
            this.props.openPanelCallback(newActiveState);
        }
    }

    render() {
      const { itemGroup, revealedContent, } = this.props;
      const { isActive, } = this.state;
      return (
          <div className={`ExpandablePanelItem
            ${isActive ? 'ExpandablePanelItem--is-active' : ''}
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
    openPanelCallback: PropTypes.func,
};

export default ExpandablePanel;
