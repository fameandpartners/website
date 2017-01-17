function PresentationHelper(){}

// Formats size option value or user profile to be returned as in
// 4'10" / 147cm | 6
// Janine's Profile
PresentationHelper.size = function(userOrSize, height, siteVersion){
  if(!userOrSize && !height){ return null; }
  if(userOrSize.user_profile) {
    return userOrSize.first_name + "'s size profile";
  } else {
    // Build a regexp to get the matching size number depeding on the site version: US|AU
    var regexp = new RegExp(siteVersion + '/?(\\d+)', 'i');
    return height + ' | ' + userOrSize.name.match(regexp)[1];
  }
};

PresentationHelper.fabricColour = function(fabric, colour){
  if(fabric && colour){
    return fabric.presentation + ' | ' + colour.presentation;
  }else{
    return '';
  }
};

PresentationHelper.costFor = function(options, customizationItem){
  if(customizationItem === 'size' || customizationItem === 'silhouette'){ return null; }
  if(customizationItem === 'fabric-colour' && options.fabric && options.colour){
    return parseInt(options.fabric.price) + parseInt(options.colour.price);
  }else if(options[customizationItem]){
    return parseInt(options[customizationItem].price);
  }
  return '';
};

PresentationHelper.additionalCost = function(options, customizationItem){
  var cost = this.costFor(options, customizationItem);
  if(cost){
    return ' + $' + cost;
  }else{
    return '';
  }
};

PresentationHelper.customization = function(customization){
  if(customization){
    return customization.presentation;
  }else{
    return '';
  }
};

PresentationHelper.presentation = function(options, customizationItem, siteVersion){
  var presentation = '';
  if(customizationItem === 'fabric-color'){
    presentation = PresentationHelper.fabricColour(options.fabric, options.colour);
    var additionalCost = PresentationHelper.additionalCost(options, customizationItem);
    return presentation + additionalCost;
  }else if(customizationItem === 'size'){
    return PresentationHelper.size(options.size, options.height, siteVersion);
  }else{
    presentation = PresentationHelper.customization(options[customizationItem]);
    additionalCost = PresentationHelper.additionalCost(options, customizationItem);
    return presentation + additionalCost;
  }
};
