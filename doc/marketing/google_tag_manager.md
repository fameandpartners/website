# Google Tag Manager (GTM) and its dataLayer

GTM is "a tool to manage marketing trackers and analytics without rebuilding your application".
In Fame's case, without the need of redeploying the application.
 
To help you better understand what is GTM and its internal workings, please refer to:  

- Original Docs: https://developers.google.com/tag-manager
- Simo Ahava's Blog (GTM and dataLayer tips): https://www.simoahava.com/category/gtm-tips/

## Usage

As a rule of thumb, think on GTM as your main tool to not pollute application templates with volatile marketing trackers.
Its possible usage can include:

- Marketing wants to add a new tracking pixel on specific pages
- A new tool is being introduced to help website remarketing/tracking
- JS based development tools for UX, like HotJar
- JS based website verification codes

## dataLayer

GTM's dataLayer is a JS array where GTM is able to read information from.
It can receive multiple pushes through page lifecycle or user interaction, being able to render tags with dynamic information as needed.

Pushing information to the `dataLayer` consists on pushing a JSON object each time you call a new `dataLayer` event. Example:

```js
dataLayer.push({ 'event': 'event_name', 'user': { name: 'John Doe', email: 'john@doe.com' } });
```

Keep in mind: the `dataLayer` object is loaded on page load time and variables are passed through further events (as DOM ready, window load, etc), as seem below:
 
![GTM Debug](gtm-debug.png)

If you want to trigger several tags on page load time, you should render the `dataLayer` populated with the desired JSON from the server side.

### Fame's dataLayer

Fame & Partners has a rich `dataLayer` setup, populating GTM with page, product and order information.

`Marketing::Gtm::Presenter`
 
 module Marketing::Gtm::Presenter::Container
   module Gtm
     module Presenter
       class Container

