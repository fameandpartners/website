import React, {Component,} from 'react';
import CollectionFastNav from '../components/CollectionFastNav.jsx';
import CollectionFilter from '../components/CollectionFilter.jsx';

export default class CollectionSidebar extends Component {
  render() {
    return (
      <div className="CollectionSidebar">
        <CollectionFastNav />
        <CollectionFilter />
      </div>
    );
  }
}
