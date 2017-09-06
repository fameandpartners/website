# CSS / SCSS

- Basic rules, heavily borrowing AirBnB's excellent styleguide as the base, with influence from Medium and some inspiration from the Skeleton boilerplate.


## General Formatting
- Use 2 spaces for indentation.
- Don't use ID selectors!
- Prefix utility classes with `u-` and use dash-casing, e.g. `u-pull-left`.
- Add a space before the opening `{` in a rule declaration.
- Add a space after the `:` in a property declaration.
- A closing brace `}` should always be on a new line.
- Separate each rule declaration with a blank line.
- Use `0` instead of `none`, e.g. `border: 0;`.
- Use a leading `0` where applicable, e.g. `font-size: 0.75em;`.
- Use `//` for comments (they will be removed by the .scss preprocessor), and don't add them to the end of a line.
- With multiple selectors, give each a new line e.g.:
```css
.SomeModule__title,
.SomeModule__content {
  border: 0;
}

// notice the spacing between rules
.AnotherModule {
  font-size: 0.75em;
}

.u-full-width {
  width: 100%;
  box-sizing: border-box;
}

// this is bad...
#please-dont-use-me {
  font-weight: bold; // commenting like this is bad too...
}
```


## SCSS Specifics
- Use `.scss` syntax, not `.sass`.
- The `@extend` directive is dangerous (Google it), but tl-dr; - don't use it!
- Put `@include`'s _after_ all of your other standard property declarations.
- Don't nest selectors more than **one-level deep** and _only_ use nesting for pseudo-selectors, e.g.:
```scss
.SomeModule__link {
  color: $link-color;

  &:hover {
    color: $link-hover-color;
  }

  @include transition(background 0.5s ease);
}
```


## CSS Rule Structure (BEM)
- Use a custom variant of BEM with PascalCase for all declarations _except_ for utility classes, which should be in the format of: `u-helper-purpose`, e.g.: `u-full-width`.
```jsx
// ListingCard.jsx
function ListingCard() {
  return (
    <article class="ListingCard ListingCard--featured">

      <h1 class="ListingCard__title">Adorable 2BR in the sunny Mission</h1>

      <div class="ListingCard__content">
        <p>Vestibulum id ligula porta felis euismod semper.</p>
      </div>

    </article>
  );
}
```

- When using BEM, block structure should be _flat_, i.e. don't reflect the nested DOM structure!
  - E.g., you should never have classnames like `Block__element__child` (more than one double-underscore should be a red flag). So, using the previous example:
```jsx
// ListingCard.jsx
function ListingCard() {
  return (
    <article class="ListingCard ListingCard--featured">

      <h1 class="ListingCard__title">Adorable 2BR in the sunny Mission</h1>

      <div class="ListingCard__content">
        <p>Vestibulum id ligula porta felis euismod semper.</p>
        <!-- DON'T do the below! -->
        <a class="ListingCard__content__link">
          THE CLASS ON THIS ELEMENT IS BAD
        </a>
        <!-- The below is how you SHOULD do it! -->
        <a class="ListingCard__link">
          BETTER
        </a>
      </div>

    </article>
  );
}
```

- Using the `--modifier` on the top level `Block` is a great way to keep your CSS maintainable.
  - For example, on the Contentful modules, there was a module for editorials that was being used in three places, but with wildly varying sizes (and thus child elements needed to be styled differently).
  - Instead of creating entirely separate elements which would've basically been duplicates, save for a few minor font & sizing differences, I just applied a `--modifier` class, and then changed the styles of the child elements as needed, e.g.:
```html
<!-- Standard Editorial -->
<div class="Editorial">
  <div class="Editorial__overlay">
    <!-- large editorial's content -->
  </div>
</div>

<!-- Extra-Large Editorial -->
<div class="Editorial Editorial--featured">
  <div class="Editorial__overlay">
    <!-- extra large editorial's content -->
  </div>
</div>

<!-- Small Editorial -->
<div class="Editorial Editorial--mini">
  <div class="Editorial__overlay">
    <!-- small editorial's content -->
  </div>
</div>
```

Then, in the CSS:
```scss
.Editorial__overlay {
  position: absolute;
  margin: 20px;
  width: calc(100% - 40px);
  text-align: center;
  color: $some-initial-color;
}

.Editorial--featured .Editorial__overlay {
  width: 320px;
  left: calc(50% - 20px);
  transform: translateX(-50%);
}

.Editorial--mini .Editorial__overlay {
  color: $for-example-purposes;
}
```


## SCSS File Structure
- Common sense rules all. Just try to keep things as modular as you can, e.g. separate files for separate modules, one for mixins, variables, any imports of an existing grid you're using, etc., e.g.:
```scss
  scss/
  |- _base/
  |  |- _variables.scss
  |  |- _mixins.scss

  |- _layouts/
  |  |- _grid.scss

  |- _modules/
  |  |- _editorial.scss
  |  |- _product.scss

  |- _components/
  |  |- _Input.scss
  |  |- _Form.scss
  |  |- _Carousel.scss

  |- _misc/
  |  |- _helpers.scss

  |- application.scss

  stylesheets/
  |- application.css
```

- As your .scss structure grows, it may make sense to have other partials to pull in sub-groups.
  - E.g. for now, `application.scss` might just contain an import statement for each of the two modules, but if you end up having 15+ modules, it may make more sense for that file to import one `_modules.scss` partial (and then this file takes care of importing each module).



### References
[AirBnB Styleguide](https://github.com/airbnb/css)

[Medium Article](https://medium.com/@fat/mediums-css-is-actually-pretty-fucking-good-b8e2a6c78b06)

[BEM F.A.Q.](http://getbem.com/faq/)

[Skeleton GitHub](https://github.com/dhg/Skeleton)
