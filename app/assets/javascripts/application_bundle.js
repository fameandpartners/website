(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);var f=new Error("Cannot find module '"+o+"'");throw f.code="MODULE_NOT_FOUND",f}var l=n[o]={exports:{}};t[o][0].call(l.exports,function(e){var n=t[o][1][e];return s(n?n:e)},l,l.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){
'use strict';

var _testcomp = require('./components/testcomp');

var _testcomp2 = _interopRequireDefault(_testcomp);

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

var comp = new _testcomp2.default();

},{"./components/testcomp":2}],2:[function(require,module,exports){
'use strict';

Object.defineProperty(exports, "__esModule", {
  value: true
});

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

var TestComp = function TestComp() {
  _classCallCheck(this, TestComp);

  console.log('Test Component');
};

exports.default = TestComp;

},{}]},{},[1]);
