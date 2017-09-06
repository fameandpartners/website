import React, { Component } from 'react';
import querystring from 'query-string';
import { isEqual } from 'lodash';
import win from '../polyfills/windowPolyfill';

/**
 * This component is a HOC that decorates a child component with query params
 * @param  {Component} DecoratedComponent
 * @return {Component} query string infused Component
 */
export default function decorateClass(DecoratedComponent) {
  class QueryStringDecorator extends Component {

    constructor(...args) {
      super(...args);
      this.state = { query: this.getQuery() };
      this.onQueryUpdate = this.onQueryUpdate.bind(this);
    }

    getQuery() {
      return querystring.parse(win.location.search.split('?').join(''));
    }

    onQueryUpdate() {
      const query = this.getQuery();
      if (isEqual(query, this.state.query));
      this.setState({ query: this.getQuery() });
    }

    componentDidMount() {
      win.addEventListener('popstate', this.onQueryUpdate);
    }

    componentWillUnmount() {
      win.removeEventListener('popstate', this.onQueryUpdate);
    }

    render() {
      return (
        <DecoratedComponent {...this.props} {...this.state} />
      );
    }
    }

  QueryStringDecorator.displayName = `QueryStringDecorator(${DecoratedComponent.displayName})`;
  return QueryStringDecorator;
}
