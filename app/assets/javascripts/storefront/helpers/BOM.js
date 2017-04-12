export function getUrlParameter(sParam){
  if (typeof window !== 'object') return '';
  const sPageURL = decodeURIComponent(window.location.search.substring(1));
  const sURLVariables = sPageURL.split('&');

  for (let i = 0; i < sURLVariables.length; i++) {
    const sParameterName = sURLVariables[i].split('=');
    if (sParameterName[0] === sParam){ return sParameterName[1];}
  }
  return '';
}

export function decodeQueryParams() {
  const queryObj = {};
  const queryStrArr = decodeURIComponent(window.location.search.substring(1))
  .replace(/\+/g, " ")
  .split('&');

  // Loop over each of the queries and build an object
  queryStrArr.forEach((query)=> {
    let [key, val,] = query.split('=');
    key = key ? key.replace(/([^a-z0-9_]+)/gi, '') : undefined; // replace key with acceptable param name

    if (key && val){ // We have an acceptable query string format
      if (!queryObj[key]){ // No previous version
        queryObj[key] = val;
      } else if (Array.isArray(queryObj[key])){ // currently an array, add to it
        queryObj[key] = [...queryObj[key], val,];
      } else {
        queryObj[key] = [queryObj[key], val,]; // not an array, create one
      }
    }
  });

  return queryObj;
}
