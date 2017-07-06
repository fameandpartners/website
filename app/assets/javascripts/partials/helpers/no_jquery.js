// http://youmightnotneedjquery.com/

function jsAddClass(elem, classToAdd) {
  if (elem.classList) {
    elem.classList.add(classToAdd);
  } else {
    elem.classToAdd += ' ' + classToAdd;
  }
}

function jsRemoveClass(elem, classToRemove) {
  if (elem.classList) {
    elem.classList.remove(classToRemove);
  } else {
    elem.classToRemove = elem.classToRemove.replace(
      new RegExp('(^|\\b)' + classToRemove.split(' ').join('|') + '(\\b|$)', 'gi'),
      ' '
    );
  }
}
