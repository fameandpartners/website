import React, {Component} from 'react';
class ReturnNavigation extends Component {
  render() {
    return (
        <ul className="Order__Navigation grid">
          <li className="list-item listitem--active col-12_md-4">
            <a href="#">Orders</a>
          </li>
          <li className="list-item col-12_md-4">
            <a href="#">Account</a>
          </li>
          <li className="list-item col-12_md-4">
            <a href="#">Saved Items</a>
          </li>
        </ul>
      );
  }
}
export default ReturnNavigation;
