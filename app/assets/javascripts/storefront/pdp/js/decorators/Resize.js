/* eslint-disable no-underscore-dangle */
import { debounce } from 'lodash';
import React, { Component } from 'react';
import window from '../polyfills/windowPolyfill';

const handlers = [];

function deferredHandlerCaller() {
  handlers.forEach((handle) => {
    if (typeof handle === 'function') {
      handle();
    }
  });
}

export default function resizeThunk(config = {}) {
  const { onResize } = config;
  const debounceTime = config.debounce || 500;


  return function decorateClass(DecoratedComponent) {
    return class Resize extends Component {

      constructor(...args) {
        super(...args);
        this.state = this.getState();
        this.onWindowResize = debounce(this.onWindowResize.bind(this), debounceTime);
      }

      getState() {
        if (typeof onResize === 'function') {
          const newState = onResize(window);
          if (newState && typeof newState === 'object') {
            return newState;
          }
        }
        return {};
      }

      onWindowResize() {
        this.setState(this.getState());
      }

      componentDidMount() {
        this._registeredIndex = handlers.length;
        handlers.push(this.onWindowResize);

        window.addEventListener('resize', () => {
          setTimeout(deferredHandlerCaller, 0);
        });
      }

      componentWillUnmount() {
        // just place null in place to not throw off index
        handlers.splice(this._registeredIndex, 1, null);
      }

      render() {
        return (
          <DecoratedComponent
            ref={c => this.child = c}
            {...this.props}
            {...this.state}
          />
        );
      }
    };
  };
}
