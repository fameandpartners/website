# CSS Guidelines

In working on large, long running projects with many contributing developers, it is important that we all work in an unified way in order to keep a common formatting and consistent commenting, syntax and naming. This will help us keep stylesheets maintainable, transparent, readable and scalable.

## Whitespace

* Use soft indents.
* Use 2 characters for the indentation level.
* Never mix spaces and tabs for indentation.
* If possible wrap syntax at 80 characters wide.

## Multiple Files

Wherever possible split discrete chunks of code into their own files.

## Titling

Use section title to break up large SCSS files into their own logical sections so they're easier to read.

```
/* [Blog posts]
-------------------------------------------------------*/
```

## TODO comments

Prefix the comment with TODO: to leave reminders of outstanding work for yourself or other developers.

```
// TODO: This section needs to be refactored
```

## !important comments

Whenever you write some styles that needs to use the !important keyword always include a comment to remained other developers that you are not using it incorrectly.

```
// !important used to override hacked styling in .btn
```

## Naming conventions

Always ensure classes are sensibly named. Keep them as short as possible but as long as necessary. Ensure any utilities are very vaguely named (e.g. .center-block) to allow for greater reuse. Never use ID's for styling.

## Naming conventions

All class names are delimited with a hyphen. Don't use camel-case and underscores.

```
// Good
.panel-heading {
  ...
}

// Bad
.panelHeading {
  ...
}
```

### Sates

Any type of style that is state based e.g. a navigation link may be in an active state, an accordion section may be in an expanded state, should be namespaced with .is-, e.g. .is-active, .is-expanded.

### Javascript

Never use a CSS styling class as a Javascript hook. Attaching JS behaviour to a styling class means that we can never have one without the other. If you need to bind to some markup use a JS specific CSS class which is namepsaced with .js-, e.g. .js-trigger-accordion.

## Formatting rules

Use one discrete selector per line in multi-selector rule sets and include a single space before the opening brace. Place the closing brace in the same column as the first character of the rule set.

```
// Good
.panel-header,
.panel-footer {
  ...
}

// Bad
.panel-header, .panel-footer{
  ...
  }
```

Properties within rule sets should each reside on their own line and use one level of indentation for each declaration.

```
// Good
.panel-header,
.panel-footer {
  margin: 0;
  padding: 0;
}

// Bad
.panel-header,
.panel-footer {
margin: 0; padding: 0;
}
```

Separate each rule set by a blank line.

```
// Good
.panel-header {
  font-size: 0.875em;
}

.panel-footer {
  font-size: 0.75em;
}

// Bad
.panel-header {
  font-size: 0.875em;
}
.panel-footer {
  font-size: 0.75em;
}
```

Include a single space after the colon.

```
// Good
margin: 0;

// Bad
margin:0;
```

Use lowercase and shorthand hex values.

```
// Good
color: #ddd;

// Bad
color: #DDDDDD;
```

Use hex or rgb values not color name.

```
// Good
color: #f00;

// Bad
color: red;
```

Use shorthand for properties that support it.

```
// Good
margin: 10px 20px;

// Bad
margin: 10px 20px 10px 20px;
```

Use single quotes.

```
content: '';
```

Where allowed, avoid specifying units for zero-values.

```
// Good:
margin: 0;

// Bad:
margin: 0px;
```

Commas in lists should be followed by a space.

```
// Good:
background: rgba(0, 0, 0, 0.5);

// Bad:
background: rgba(0,0,0,0.5);
```

!important !important !important Try to avoid using it, if you must use it include a space before !important keyword.

```
// Good:
margin: 0 !important;

// Bad:
margin: 0!important;
```

Property values and variable declarations should always end with a semicolon.

```
// Good:
margin: 0;

// Bad:
margin: 0
```

Parentheses should not be padded with spaces.

```
// Good:
@include box-shadow(0 2px 2px rgba(0, 0, 0, .2));

// Bad:
@include box-shadow( 0 2px 2px rgba( 0, 0, 0, .2 ) );
```

Don't write trailing zeros for numeric values with a decimal point.

```
// Good
margin: 0.5em;

// Bad
margin: 0.500em;
```

When a decimal mark is needed always include the zero.

```
// Good
margin: 0.5em;

// Bad
margin: .5em;
```

Declared properties should be grouped into logical block.

```
// Good
.panel-header {
  position: relative;
  width: 100%;
  height: 50px;
  font-size: 0.875em;
  font-weight: 300;
  border-color: #ddd;
  background: #fff;
}

// Bad
.panel-header {
  border-color: #ddd;
  height: 50px;
  font-size: 0.875em;
  width: 100%;
  background: #fff;
  font-weight: 300;
  position: relative;
}
```

## SCSS format considerations

Try to limit nesting to 1 level deep. This prevents overly-specific CSS selectors.

```
// Good:
.panel {
  ...

  .inner-wrap {
   ...
  }

  .panel-heading {
    ...
  }

}

// Bad:
.panel {
  ...

  .panel-heading {
    ...

    .inner-wrap {
      ...
    }

  }

}
```

Indent child rule sets and include blank line before and after each set.

```
// Good:
.panel {
  ...

  .inner-wrap {
   ...
  }

  .panel-heading {
    ...
  }

}

// Bad:
.panel {
  ...
.inner-wrap {
  ...
}
.panel-heading {
  ...
}
}
```

Do not use parent selector references (&) when they would otherwise be unnecessary.

```
// Good:
.panel {

  > .inner-wrap {
    ...
  }

}

// Bad:
.panel {

  & > .inner-wrap {
    ...
  }

}
```
