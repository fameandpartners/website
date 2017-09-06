import CustomEvent from 'custom-event';

/**
 * dispatch custom events
 *
 * @param  {element} el         slideshow element
 * @param  {string}  type       custom event name
 * @param  {object}  detail     custom detail information
 */
export default function dispatchEvent(target, type, detail) {
  const event = new CustomEvent(
    type,
    {
      bubbles: true,
      cancelable: true,
      detail,
    },
  );

  target.dispatchEvent(event);
}
