import { spring } from 'react-motion';


export const STANDARD_DEFAULT_STYLES = {
  key: 'modal',
  style: {
    opacity: spring(1),
    y: spring(0),
  },
};

export const SLIDE_UP_DEFAULT_STYLES = {
  key: 'modal',
  style: {
    opacity: spring(1),
    y: spring(0),
    x: 0,
  },
};

export const SLIDE_LEFT_DEFAULT_STYLES = {
  key: 'modal',
  style: {
    opacity: spring(1),
    x: spring(0),
    y: 0,
  },
};

export const SLIDE_OVER_DEFAULT_STYLES = {
  key: 'slide-over',
  style: {
    opacity: spring(1),
    x: spring(0),
  },
};

export const STANDARD_WILL_ENTER = {
  opacity: 0,
  y: -3,
};

export const SLIDE_UP_WILL_ENTER = {
  opacity: 0,
  y: 100,
  x: 0,
};

export const SLIDE_LEFT_WILL_ENTER = {
  opacity: 0,
  x: 100,
  y: 0,
};

export const SLIDE_OVER_WILL_ENTER = {
  opacity: 0,
  x: 50,
};

export const STANDARD_WILL_LEAVE = {
  opacity: spring(0),
  y: spring(-10),
};

export const SLIDE_UP_WILL_LEAVE = {
  y: spring(100),
  x: 0,
};

export const SLIDE_LEFT_WILL_LEAVE = {
  x: spring(100),
  y: 0,
};

export const SLIDE_OVER_WILL_LEAVE = {
  opacity: spring(0),
  x: spring(50),
};

export default {
  STANDARD_DEFAULT_STYLES,
  SLIDE_UP_DEFAULT_STYLES,
  SLIDE_LEFT_DEFAULT_STYLES,
  SLIDE_OVER_DEFAULT_STYLES,
  STANDARD_WILL_ENTER,
  SLIDE_UP_WILL_ENTER,
  SLIDE_LEFT_WILL_ENTER,
  SLIDE_OVER_WILL_ENTER,
  STANDARD_WILL_LEAVE,
  SLIDE_UP_WILL_LEAVE,
  SLIDE_LEFT_WILL_LEAVE,
  SLIDE_OVER_WILL_LEAVE,
};
