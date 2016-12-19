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
